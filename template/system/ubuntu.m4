include(envs.m4)
HIDE

define(`UBUNTU_CODENAME',`ifelse(
$1,18.04,bionic,
$1,20.04,focal,
`ERROR(`ubuntu codename not known for the $1 version')')')

UNHIDE
