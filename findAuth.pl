#!/usr/bin/perl -w
use warnings;
use strict;
use Spreadsheet::ParseExcel;
use Spreadsheet::WriteExcel;
use utf8;

sub getAuthName
{
  my ($logLine) = @_;
  my $authName;

  if($logLine =~ /r\d+ \| (\w+) \|.*/)
  {
    $authName = $1;
  }

  return $authName;
}

my $newWorkBook   = Spreadsheet::WriteExcel->new("result.xls");
my $newWorkSheet  = $newWorkBook->add_worksheet();
my $listParser    = Spreadsheet::ParseExcel->new();
my $listWorkBook  = $listParser->parse("list.xls");
if(!defined $listWorkBook)
{
	die $listParser->error(), ".\n";
}

my $listWorkSheet = $listWorkBook->worksheet(0);
my ($row_min, $row_max) = $listWorkSheet->row_range();

for my $row ($row_min .. $row_max)
{
	my $appNameCell = $listWorkSheet->get_cell($row, 0);
	next unless $appNameCell;
	my $appName = $appNameCell->value();
	$newWorkSheet->write($row, 0, $appName);

	my $numCell = $listWorkSheet->get_cell($row, 1);
	next unless $numCell;
	my $num = $numCell->value();
	$newWorkSheet->write($row, 3, $num);

	my $dirPath = readpipe("find v7trunk/app -name $appName");
	while( $dirPath =~ s/(\/\w+?) (\w+?\/)/$1\\ $2/ )
	{
	}
  $dirPath =~ s/ and /\\ and\\ /;

	my @svnLog = readpipe("svn log $dirPath");
	if(!defined $svnLog[1])
	{
		$newWorkSheet->write($row, 1, 'NULL');
		next;
	}
	if(!defined $svnLog[5])
	{
		my $authName1 = & getAuthName($svnLog[1]);
		$newWorkSheet->write($row, 1, "$authName1");
		next;
	}
	else
	{
		my $authName1 = & getAuthName($svnLog[1]);
		my $authName2 = & getAuthName($svnLog[5]);
		$newWorkSheet->write($row, 1, "$authName1");

		if($authName2 ne $authName1)
		{
			$newWorkSheet->write($row, 2, "$authName2");
		}
	}
}

