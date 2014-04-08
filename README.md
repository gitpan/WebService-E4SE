# WebService::E4SE [![Build Status](https://travis-ci.org/genio/webservice-e4se.svg?branch=master)](https://travis-ci.org/genio/webservice-e4se)

[Epicor E4SE](http://www.epicor.com/Products/Pages/E4SE.aspx) software uses a clunky, IE-only interface (just try to fill in your timesheet with a non-windows machine! I dare ya!).

Each action on the software calls a SOAP-based web service API method. However, the APIs are not neatly packaged in one place (a la Salesforce, etc.). Also, there are no sessions. So, each call to the API must send username and password credentials all over again (using NTLM).

There are more than 100 web service files you could work with (.asmx extensions) each having their own set of methods. Some of these are grouped somewhat logically, some are not. On your installation of E4SE, you can get a listing of method calls available by visiting one of those files directly [Resource.asmx](http://epicor/e4se/Resource.asmx) for example).

The purpose of this module is to somewhat abstract out the tedium of dealing with all of this stuff.

## Features

  * An easy to use API documented [here](https://metacpan.org/pod/WebService::E4SE).

## Installation

  All you need is a one-liner, it takes less than a minute.

    $ cpan install WebService::E4SE

  We recommend the use of a [Perlbrew](http://perlbrew.pl) environment.

## Getting Started

  These three lines are a whole web application.

```perl
#!/usr/bin/env perl

#some boiler-plate stuff that I always do:
use strict;
use warnings;
use utf8;
use IO::Handle();
use feature ':5.10';

#necessary bits
use WebService::E4SE;

# create a new object
my $ws = WebService::E4SE->new(
  username => 'AD\username',                  # NTLM authentication
  password => 'A password',                   # NTLM authentication
  realm => '',                                # LWP::UserAgent and Authen::NTLM
  site => 'epicor:80',                        # LWP::UserAgent and Authen::NTLM
  base_url => URL->new('http://epicor/e4se'), # LWP::UserAgent and Authen::NTLM
  timeout => 30,                              # LWP::UserAgent
);
 
# get an array ref of web service APIs to communicate with
my $res = $ws->files();
say Dumper $res;
 
# returns a list of method names for the file you wanted to know about.
my @operations = $ws->operations('Resource.asmx');
say Dumper @operations;
 
# call a method and pass some named parameters to it
my ($res,$trace) = $ws->call('Resource.asmx','GetResourceForUserID', userID=>'someuser');
 
# give me the XML::Compile::WSDL11 object
my $wsdl = $ws->get_object('Resource.asmx'); #returns the usable XML::Compile::WSDL11 object
```

## Want to know more?

  Take a look at our [documentation](https://metacpan.org/pod/WebService::E4SE>)!

