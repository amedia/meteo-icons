#
# This script is only for the maintainers of this repo.

# Script for renaming files and folders for Weather Icons produced
# by the design team at Amedia Utvikling (Marius)
#
# You will receive a zipped file from design with a lot of svg files in
# the following structure
#
# /værikoner
#    /dag
#    /natt
#    /polar
#
# The icon files are named something like : weather-master\(04\)_23\ SleetThunder.svg
# The script will create a new weatherbundle directory and with the sub-directories
# day, night and polar.
#
# All icons in the "værikoner" directory will be copied to the new weatherbundle directory
# and renamed to for example 23.svg (taken from the old filename).
#
# The new weatherbundle folder can be copied to Arena (Castor) or whereever you need it.
# The number of the files matches the Symbol id in the api.met.no apis.
#
# Author: Jakob Vad Nielsen
#
# Usage:
#
# * Get the weather icons zip file from Marius (or somebody else at the design team)
# * Unzip the file (This should give you a 'værikoner' directory)
# * From the same directory run this script (This will create the 'weatherbundle' directory)
# * Copy the content of the 'weatherbundle' directory to where you need it.
#
require 'fileutils'

$BDIR = "weatherbundle"

def renameFiles(path)
	Dir.entries(path).select {|f| 
		if f.include? "svg"
			newName = /.*_0?(.*)\s.*/.match(f)[1] 
			FileUtils.mv path + f, path + newName + ".svg", :verbose => true
		end
	}   
end

def handleDir(newname, oldname, dorename)
	FileUtils.cp_r "værikoner/" + oldname, $BDIR, :verbose => true
	$ndir = $BDIR + "/" + newname
	FileUtils.mv $BDIR + "/" + oldname, $ndir, :verbose => true if dorename
	renameFiles($ndir + "/")
end

if Dir.exists? $BDIR
	abort $BDIR + "already exists!"
end
FileUtils.mkdir($BDIR)
handleDir("day", "dag", true)
handleDir("night", "natt", true)
handleDir("polar", "polar", false)