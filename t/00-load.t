use strict;
use warnings FATAL => 'all';
use Test::More tests => 21;
use URI;

use FindBin;
use lib "$FindBin::Bin/lib";

BEGIN {
	use_ok( 'WebService::E4SE' ) || print "Bail out!\n";
}

my $ws = WebService::E4SE->new();
can_ok(
	'WebService::E4SE',
	qw(useragent timeout username password realm site base_url wsdl force_wsdl_reload files call get_object operations)
);
isa_ok($ws,'WebService::E4SE');
isa_ok($ws->useragent(),'LWP::UserAgent');
ok($ws->username eq '');
ok($ws->username('foo') eq 'foo');
ok($ws->password eq '');
ok($ws->password('foo') eq 'foo');
ok($ws->timeout == 30);
ok($ws->timeout(1) == 1);
ok($ws->realm eq '');
ok($ws->realm('foo') eq 'foo');
ok($ws->site eq 'epicor:80');
ok($ws->site('foo') eq 'foo');
isa_ok($ws->base_url(),'URI');
ok($ws->base_url eq 'http://epicor/e4se');
ok($ws->base_url(URI->new('http://foo.com')) eq 'http://foo.com');
isa_ok($ws->wsdl, 'HASH');
ok($ws->force_wsdl_reload eq 0);
ok($ws->force_wsdl_reload(1) eq 1);
isa_ok($ws->files, 'ARRAY');


#diag( "Testing WebService::E4SE $WebService::E4SE::VERSION, Perl $], $^X" );
