all: install start

install:
	git remote update
	git rebase --no-ff -f origin/extras
	npm install

start:
	npm start

.PHONY: install start
