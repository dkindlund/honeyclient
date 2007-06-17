use HoneyClient::DB::File;
use HoneyClient::DB::Note;
use HoneyClient::DB::Fingerprint;
use HoneyClient::DB::Regkey;

my $note = {
    note => "Bad Things happened!",
    category => "behavior",
    analyst => "Jiminy Cricket",
};
my $note2 = {
    note => "Wierdness",
    category => "stuff",
    analyst => "Rocky Balboa",
};
my $content = {
	md5  => '82da9a561687f841a61e752e401471d2',
	sha1 => '7552ad083713e6d6b79539b64d598d4dcadfba35',
	size => 114688,
	type => 'MS-DOS executable (EXE), OS/2 or MS Windows',
	notes => [$note, $note2],
};
my $file  = {
    name => 'c:\windows\system32\\calc.exe',
    status => $HoneyClient::DB::STATUS_ADDED,
    content => $content,

};
my $entry1 = {
	name => 'foo',
	new_value => 'fighters',
	old_value => 'bar',
};
my $entry2 = {
	name => 'Super',
	new_value => 'Chunk',
	old_value => 'man'
};
my $entry3 = {
	name => 'foo3',
	new_value => 'fighters3',
	old_value => 'bar3',
};
my $entry4 = {
	name => 'Super4',
	new_value => 'Chunk4',
	old_value => 'man4'
};
my $rk = {
	key_name => 'HKLM\Software\Microsoft\Windows\CurrentVersion\Run',
	entries => [$entry1,$entry2],
	status => $HoneyClient::DB::STATUS_MODIFIED,
};
my $rk2 = {
	key_name => 'HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce',
	entries => [$entry3,$entry4],
	status => $HoneyClient::DB::STATUS_MODIFIED,
};

my $fingerprint = HoneyClient::DB::Fingerprint->new({
	filesystem => [$file],
	registry => [$rk, $rk2],
	vmid => 'abcTestVmIDString42a9fd5f1',
	lasturl => 'http://naughty.evilbadsite.com',
});

#print Data::Dumper::Dumper($fingerprint)."\n\n";

$fingerprint->insert();

my $dbh = $HoneyClient::DB::dbhandle;

use Data::Dumper;

print Dumper(HoneyClient::DB::File->select({
    path => 'c:\windows\system32',
    name => 'calc.exe',
    content => 1,
},HoneyClient::DB::File->get_fields())
)."\n";
