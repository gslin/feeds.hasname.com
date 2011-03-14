#
DATE?=		date
ID?=		id
RSYNC?=		rsync
RSYNC_OPT?=	-av --delete-after --exclude .git

#
all: update

deploy: update
	${RSYNC} ${RSYNC_OPT} ./ feeds.hasname.com:/var/www/feeds.hasname.com/

push:
	${GIT} push -v

update:
	(${ID}; ${DATE}) > update.txt
