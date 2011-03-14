#
DATE?=		date
GIT?=		git
ID?=		id
RSYNC?=		rsync
RSYNC_OPT?=	-av --delete-after --exclude .git

#
all: update

deploy: pull update
	${RSYNC} ${RSYNC_OPT} --exclude webroot/feed/ ./ feeds.hasname.com:/var/www/feeds.hasname.com/

pull:
	${GIT} pull -v

push:
	${GIT} push -v

update:
	(${ID}; ${DATE}) > update.txt
