#!/bin/bash
# The goal of this script is to speed up development destroying all images
# when needed, not advised to use as a stop script for Docker.
########################################################################
########################################################################
##                    STOP all containers                             ##
########################################################################
########################################################################

echo '####################################################'
echo '                Stop Containers                     '
echo '####################################################'
docker stop $(docker ps -aq)


########################################################################
########################################################################
##                    REMOVE all containers                           ##
########################################################################
########################################################################


echo '####################################################'
echo '                Remove Containers                   '
echo '####################################################'
docker rm $(docker ps -aq)

########################################################################
########################################################################
##                        Clean System                                ##
########################################################################
########################################################################


echo '####################################################'
echo '                System Prune                        '
echo '####################################################'
docker system prune -f

