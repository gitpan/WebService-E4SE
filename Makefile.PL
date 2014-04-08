use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'WebService::E4SE',
    AUTHOR           => q{Chase Whitener <cwhitener@gmail.com>},
    VERSION_FROM     => 'lib/WebService/E4SE.pm',
    ABSTRACT_FROM    => 'lib/WebService/E4SE.pm',
    LICENSE          => 'Artistic_2_0',
	META_MERGE   => {
		requires  => {perl => '5.010001'},
		resources => {
			homepage    => 'http://cwhitener.com',
			license     => 'http://www.opensource.org/licenses/artistic-license-2.0',
			# MailingList => 'http://groups.google.com/group/mojolicious',
			repository  => 'http://github.com/genio/webservice-e4se',
			bugtracker  => 'http://github.com/genio/webservice-e4se/issues'
		},
		no_index => {directory => ['t']}
	},
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
		'Test::Pod' => 0,
		'Test::Pod::Coverage' => 0,
    },
    PREREQ_PM => {
        'XML::Compile::SOAP' => 2.38,
        'XML::Compile::WSDL11' => 2.38,
        'XML::LibXML' => 1.94,
        'Authen::NTLM' => 1.0,
        'HTTP::Headers' => 6.0,
        'HTTP::Request' => 6.0,
        'LWP::UserAgent' => 6.0,
        'Moose' => 2.0,
        'MooseX::Types::Moose' => 0.2,
        'URI' => 1.6,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'WebService-E4SE-*' },
	test => {TESTS => 't/*.t'},
);
