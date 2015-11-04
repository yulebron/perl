use strict;
use warnings;
use Spreadsheet::ParseExcel;
use utf8;

sub printOneLine()
{
  my ($cellphone, $studentid) = @_;
  
  my $printLine = "\"$studentid\",\"1445656228\",,,,,,,,\"$cellphone\",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\"".
                  "E:\\\\yulebron\\\\ftp\",,,,\"0\",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,\"welcome to Dian TX\",,,,,,\"".
                  "2,4,Dir,E:\\\\yulebron\\\\ftp\\\\USER\\\\$studentid,Access,4383,2,Dir,E:\\\\yulebron\\\\ftp\\\\PUBLIC\",,,,,,,,,\n";
  print FILE $printLine;
  
  my $dirName = "test\\$studentid";
  if( !(-e $dirName) )
  {
    mkdir($dirName) or die "make dir failed";
  }
  
}

if($#ARGV != 1)
{
  print "please enter a excel file name\n";
  exit(1);
}

my $file_name = $ARGV[0];

#打开目标excel
my $parser   = Spreadsheet::ParseExcel->new();
#指定excel路径
my $workbook = $parser->parse("$file_name");
if(!defined $workbook)
{
  die $parser->error(), ".\n";
}

#打开sheet1,取行号
my $worksheet = $workbook->worksheet(0);
my ($row_min, $row_max) = $worksheet->row_range();

#打开生成的txt
open(FILE, "> ftp_cfg.txt") or die "Fail to open ftp_cfg.txt";

for my $row ($row_min .. $row_max)
{
  my $cellphone_cell = $worksheet->get_cell($row, 1);
  next unless $cellphone_cell;
  my $studentid_cell = $worksheet->get_cell($row, 3);
  next unless $studentid_cell;
  
  my $cellphone = $cellphone_cell->value();
  my $studentid = $studentid_cell->value();
  & printOneLine($cellphone, $studentid);
}

close(FILE);
