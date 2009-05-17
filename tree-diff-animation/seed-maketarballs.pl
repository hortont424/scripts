for(my $asdf = 1100; $asdf > 0; $asdf--)
{
	`cp -r seed-git seed-$asdf`;
	`git --git-dir=seed-$asdf/.git --work-tree=seed-$asdf checkout HEAD~$asdf`;
	`rm -rf seed-$asdf/.git`;
	`tar -cf seed-$asdf.tar seed-$asdf`;
}