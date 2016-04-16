URL=file:///home/johannes/pro/git/svn-migrate/svnrepo

ALL: svn gitrepo

clean:
	rm -rf svnrepo svn gitrepo
svnrepo:
	svnadmin create svnrepo
	svn mkdir ${URL}/simple/trunk ${URL}/simple/branches ${URL}/simple/tags -m "New project simple" --parents

svn: svnrepo
	svn checkout ${URL}/simple/trunk svn

gitrepo:
	mkdir gitrepo
	git init gitrepo
	cd gitrepo && ../example_change.sh 1 example1
	cd gitrepo && ../example_change.sh 2 example2
	cd gitrepo && git tag -a blub-1.0 -m "release blub-1.0"
	cd gitrepo && ../example_change.sh 1 example3
	cd gitrepo && ../example_change.sh 1 example4
	cd gitrepo && ../example_change.sh 1 example5
	cd gitrepo && git tag -a blub-2.0 -m "release blub-2.0"
	cd gitrepo && ../example_change.sh 1 example6
	cd gitrepo && ../example_change.sh 1 example7

merger: gitrepo svnrepo
	git svn clone -s ${URL}/simple merger
	cd merger && git remote add old ../gitrepo && git fetch old
	cd merger && git checkout -b old_master old/master
	cd merger && git rebase --onto master --root 
	cd merger && git svn dcommit --add-author-from
