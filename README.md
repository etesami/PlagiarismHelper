# Plagiarism Helper
This script helps to prepare assignment submissions for plagiarism checking. You need to provide a folder that contains submission for each user (group) and the script will:
- Handles submissions per group (only considers one submission per group)
- Extract files from either `tar.gz` or `zip` format
- Store information about empty submissions
- Collects all specified files format (e.x. *.c, *.cpp, etc.) and puts all of them into a directory named by the person who has submitted.

Once the script is finished, you need to use some plagiarism tools to continue finding plagiarism. 

### Requirements
This tool depends on **docopts** to parse the input arguments.