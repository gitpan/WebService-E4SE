package WebService::E4SE;

use 5.006;
use Moose;
use MooseX::Types::Moose qw/Bool HashRef/;
use Carp;

use Authen::NTLM 1.09;
use LWP::UserAgent 6.02;
use HTTP::Headers;
use HTTP::Request;
use URI 1.60;
use XML::Compile::SOAP11 2.38;
use XML::Compile::SOAP11::Client;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
use XML::LibXML;

use namespace::autoclean;

=head1 NAME

WebService::E4SE - Communicate with the various Epicor E4SE web services.

=head1 VERSION

Version 0.02

=cut

our $AUTHORITY = 'cpan:CAPOEIRAB';
our $VERSION = '0.02';
#$Carp::Verbose = 1;
has useragent => (
	is => 'ro',
	isa => 'LWP::UserAgent',
	required => 1,
	init_arg => undef,
	default => sub {
		my $lwp = LWP::UserAgent->new( keep_alive=>1 )
	}
);

has timeout => (
	is => 'rw',
	isa => 'Int',
	required => 1,
	default => 30,
);

has username => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	default => '',
);

has password => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	default => '',
);

has realm => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	default => '',
);

has site => (
	is => 'rw',
	isa => 'Str',
	required => 1,
	default => 'epicor:80',
);

has base_url => (
	is => 'rw',
	isa => 'URI',
	required => 1,
	default => sub {
		URI->new('http://epicor/e4se')
	}
);

has wsdl => (
	is => 'rw',
	isa => 'HashRef[XML::Compile::WSDL11]',
	required => 0,
	init_arg => undef,
	lazy => 1,
	default => sub { {} },
);

has force_wsdl_reload => (
	is => 'rw',
	isa => 'Bool',
	required => 1,
	default => 0
);

has files => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	required => 1,
	lazy => 1,
	init_arg => undef,
	default => sub {[
		'ActionCall.asmx',
		'Attachment.asmx',
		'BackOfficeAP.asmx',
		'BackOfficeAR.asmx',
		'BackOfficeCFG.asmx',
		'BackOfficeGB.asmx',
		'BackOfficeGL.asmx',
		'BackOfficeIV.asmx',
		'BackOfficeMC.asmx',
		'Billing.asmx',
		'Business.asmx',
		'Carrier.asmx',
		'CommercialTerms.asmx',
		'Company.asmx',
		'ControllingProject.asmx',
		'CostVersion.asmx',
		'CRMClientHelper.asmx',
		'Currency.asmx',
		'Customer.asmx',
		'ECSClientHelper.asmx',
		'Employee.asmx',
		'ExchangeInterface.asmx',
		'Expense.asmx',
		'FinancialsAP.asmx',
		'FinancialsAR.asmx',
		'FinancialsCFG.asmx',
		'FinancialsGB.asmx',
		'FinancialsGL.asmx',
		'FinancialsMC.asmx',
		'FinancialsSync.asmx',
		'GLAccount.asmx',
		'IntersiteOrder.asmx',
		'InventoryLocation.asmx',
		'Journal.asmx',
		'Location.asmx',
		'LotSerial.asmx',
		'Manufacturer.asmx',
		'Material.asmx',
		'MaterialPlan.asmx',
		'MiscItems.asmx',
		'MSProject.asmx',
		'MSProjectEnterpriseCustomFieldsandLookupTables.asmx',
		'Opportunity.asmx',
		'Organization.asmx',
		'PartMaster.asmx',
		'Partner.asmx',
		'PriceStructure.asmx',
		'Project.asmx',
		'Prospect.asmx',
		'PSAClientHelper.asmx',
		'PurchaseOrder.asmx',
		'Receiving.asmx',
		'Recognize.asmx',
		'Resource.asmx',
		'SalesCycleManagement.asmx',
		'SalesOrder.asmx',
		'SalesPerson.asmx',
		'Shipping.asmx',
		'Site.asmx',
		'Supplier.asmx',
		'svActionCall.asmx',
		'svAttachment.asmx',
		'svBackOfficeAP.asmx',
		'svBackOfficeAR.asmx',
		'svBackOfficeCFG.asmx',
		'svBackOfficeGB.asmx',
		'svBackOfficeGL.asmx',
		'svBackOfficeIV.asmx',
		'svBackOfficeMC.asmx',
		'svBilling.asmx',
		'svBusiness.asmx',
		'svCarrier.asmx',
		'svCommercialTerms.asmx',
		'svCompany.asmx',
		'svControllingProject.asmx',
		'svCostVersion.asmx',
		'svCRMClientHelper.asmx',
		'svCurrency.asmx',
		'svCustomer.asmx',
		'svECSClientHelper.asmx',
		'svEmployee.asmx',
		'svExchangeInterface.asmx',
		'svExpense.asmx',
		'svFinancialsAP.asmx',
		'svFinancialsAR.asmx',
		'svFinancialsCFG.asmx',
		'svFinancialsGB.asmx',
		'svFinancialsGL.asmx',
		'svFinancialsMC.asmx',
		'svFinancialsSync.asmx',
		'svGLAccount.asmx',
		'svIntersiteOrder.asmx',
		'svInventoryLocation.asmx',
		'svJournal.asmx',
		'svLocation.asmx',
		'svLotSerial.asmx',
		'svManufacturer.asmx',
		'svMaterial.asmx',
		'svMaterialPlan.asmx',
		'svMiscItems.asmx',
		'svMSProject.asmx',
		'svMSProjectEnterpriseCustomFieldsandLookupTables.asmx',
		'svOpportunity.asmx',
		'svOrganization.asmx',
		'svPartMaster.asmx',
		'svPartner.asmx',
		'svPriceStructure.asmx',
		'svProject.asmx',
		'svProspect.asmx',
		'svPSAClientHelper.asmx',
		'svPurchaseOrder.asmx',
		'svReceiving.asmx',
		'svRecognize.asmx',
		'svResource.asmx',
		'svSalesCycleManagement.asmx',
		'svSalesOrder.asmx',
		'svSalesPerson.asmx',
		'svShipping.asmx',
		'svSite.asmx',
		'svSupplier.asmx',
		'svSysArtifact.asmx',
		'svSysDirector.asmx',
		'svSysDomainInfo.asmx',
		'svSysNotify.asmx',
		'svSysSearchManager.asmx',
		'svSysSecurity.asmx',
		'svSysWorkflow.asmx',
		'svTax.asmx',
		'svTime.asmx',
		'svUOM.asmx',
		'SysArtifact.asmx',
		'SysDirector.asmx',
		'SysDomainInfo.asmx',
		'SysNotify.asmx',
		'SysSearchManager.asmx',
		'SysSecurity.asmx',
		'SysWorkflow.asmx',
		'Tax.asmx',
		'Time.asmx',
		'UOM.asmx',
	]},
);

sub _get_port {
	my ( $self, $file ) = @_;
	return "WSSoap" unless defined($file) and length($file);
	$file =~ s/\.\w+$//; #strip extension
	return $file."WSSoap";
}

sub _valid_file {
	my ( $self, $file ) = @_;
	return 0 unless defined $file and length $file;
	return 1 if (grep {$_ eq $file} @{$self->files});
	return 0;
}

sub _wsdl {
	my ( $self, $file ) = @_;
	my $wsdl = $self->wsdl();
	#if our wsdl is already setup, let's just return
	return 1 if ( exists($wsdl->{$file}) && defined($wsdl->{$file}) );

	#wsdl doesn't exist.  let's setup the user agent for our transport and move along
	$self->useragent->credentials( $self->site, $self->realm, $self->username, $self->password );
	$self->useragent->timeout($self->timeout);

	my $res = $self->useragent->get($self->base_url . '/'. $file . '?WSDL' );
	unless ( $res->is_success ) {
		Carp::carp( "Unable to setup WSDL: ".$res->status_line() );
		return 0;
	}
	$wsdl->{$file} = XML::Compile::WSDL11->new( $res->decoded_content );
	unless ( $wsdl->{$file} ) {
		Carp::carp( "Unable to create new XML::Compile::WSDL11 object" );
		return 0;
	}
	my $trans = XML::Compile::Transport::SOAPHTTP->new(
		user_agent=> $self->useragent,
		address => $self->base_url.'/'. $file,
	);
	unless ( $trans ) {
		Carp::carp( "Unable to create new XML::Compile::Transport::SOAPHTTP object" );
		return 0;
	}
	$wsdl->{$file}->compileCalls(
		port => $self->_get_port($file),
		transport => $trans,
	);
	return 1;
}

=head1 SYNOPSIS

Epicor's L<http://www.epicor.com/Products/Pages/E4SE.aspx> E4SE software
uses a clunky, IE-only interface (just try to fill in your timesheet with
a non-windows machine!  I dare ya!).

Each action on the software calls a SOAP-based web service API method.
However, the APIs are not neatly packaged in one place (a la Salesforce, etc.).
Also, there aren't any sessions. So, each call to the API must send username 
and password credentials all over again (using NTLM).

There are more than 100 web service files you could work with (.asmx extensions)
each having their own set of methods.  Some of these are grouped somewhat logically,
some are not.  On your installation of E4SE, you can get a listing of method calls
available by visiting one of those files directly (L<http://epicor/e4se/Resource.asmx>
for example).

The purpose of this module is to somewhat abstract out the tedium of dealing with
all of this stuff.

The module will grab the WSDL from the file you're trying to deal with.  It will make
use of that WSDL with L<XML::Compile::WSDL11>.  You can force a reload of the WSDL at any
time.  So, we build the L<XML::Compile::WSDL11> object and hold onto it for any further
calls to that file.  These are generated by the calls you make, so hopefully we don't
kill you with too many objects.  You can work directly with the new L<XML::Compile::WSDL11>
object if you like, or use the abstracted out methods listed below.

For transportation, we're using L<XML::Compile::Transport::SOAPHTTP> using L<LWP::UserAgent> with L<Authen::NTLM>.

Here's some sample code:

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

=head1 METHODS

=head2 new( %params )

The constructor will give you a new WebService::E4SE object.  The parameters passed to it are all listed below.  They have defaults and since this is a L<Moose> object, you can set each one individually as well by using the parameter name as a method call.

=over

=item parameters

=over

=item username

Default is an empty string.  Usually, you need to prefix this with the domain your E4SE installation is using. 'AD\myusername'

=item password

Default is an empty string.  This will be your domain password.  No attempt to hide this is made as E4SE cannot function over SSL anyway, why should I bother trying to make you feel secure when you're not.

=item realm

Default is an empty string.  Again, this is for the L<Authen::NTLM> module and can generally be left blank. 

=item site

Default is 'epicor:80'.  This is for the L<Authen::NTLM> module.  Set this accordingly

=item base_url

Type is L<URL>. Default is URL->new('http://epicor/e4se').  This should be the base installation path to your E4SE installation.

=item timeout

Default is 30.  This is passed to L<LWP::UserAgent> to handle how long you want to wait on responses.

=back

=back

=head2 files()

This method will return a reference to an array of file names that this web service has knowledge of for an E4SE installation.

  my $files = $ws->files;  # 'ActionCall.asmx', 'Company.asmx', 'Resource.asmx', etc....

=head2 call( $file, $function, %parameters )

This method will call an API method for the file you want.  It will return 0 and warn on errors outside of L<XML::Compile::WSDL11>'s knowledge, otherwise it's just a little wrapper around L<XML::Compile::WSDL11>->call();

Another way to do this would be $ws->get_object('Reource.asmx')->call( $function, %params );

=over

=item $file

This is the string name of the file (also the WSDL11 object) you wish to deal with.  'Resource.asmx' for example.

=item $function

This is the string name of the function you want to call in the file's API.  'GetResourceForUserID' for xample.

=item %parameters

This is a hash of name => value pairs to be passed in for the function call.  This is XML escaped properly by L<XML::Compile::WSDL11>.

=back

=head2 get_object( $file )

This method will return an L<XML::Compile::WSDL11> object for the string file name you supply.  This handles going to the file's WSDL URL,
grabbing that URL with L<LWP::UserAgent> and L<Authen::NTLM>, and using that WSDL response to setup a new L<XML::Compile::WSDL11> object.  Note
that if you have previously setup a L<XML::Compile::WSDL> object for that file name, it will just return that object rather than going to the
server and requesting a new WSDL.

=head2 force_wsdl_reload(0)

This property is defaulted to false (0).  If set to true, the next call to a method that would require a L<XML::Compile::WSDL11> object will
go out to the server and re-grab the WSDL and re-setup that WSDL object no matter if we have already generated it or not.  The property will
be reset to false directly after the next WSDL object setup.

=head2 operations( $file )

This method will return a list of  L<XML::Compile::SOAP::Operation> objects that are available for the given file.

=cut

sub call {
	my ( $self, $file, $function, %parameters ) = @_;
	unless ( $self->_valid_file($file) ) {
		Carp::carp( "$file is not a valid web service found in E4SE." );
		return 0;
	}
	my $wsdl = $self->wsdl();
	if ( $self->force_wsdl_reload() ) {
		delete($wsdl->{$file}) if exists($wsdl->{$file});
		$self->force_wsdl_reload(0);
	}
	return 0 unless $self->_wsdl($file);

	return $wsdl->{$file}->call($function,%parameters);
}

sub get_object {
	my ( $self, $file ) = @_;
	unless ( $self->_valid_file($file) ) {
		Carp::carp( "$file is not a valid web service found in E4SE." );
		return 0;
	}
	my $wsdl = $self->wsdl;
	if ( $self->force_wsdl_reload() ) {
		delete($wsdl->{$file}) if exists($wsdl->{$file});
		$self->force_wsdl_reload(0);
	}
	return 0 unless $self->_wsdl($file);
	return $wsdl->{$file};
}

sub operations {
	my ( $self, $file ) = @_;
	unless ( $self->_valid_file($file) ) {
		Carp::carp( "$file is not a valid web service found in E4SE." );
		return [];
	}
	if ( $self->force_wsdl_reload() ) {
		delete($self->wsdl->{$file}) if exists($self->wsdl->{$file});
		$self->force_wsdl_reload(0);
	}
	unless ( $self->_wsdl($file) ) {
		return [];
	}
	my @ops = $self->wsdl->{$file}->operations(port=>$self->_get_port($file));
	my @ret = ();
	for my $op ( @ops ) {
		push @ret, $op->name;
	}
	return @ret if wantarray;
	return \@ret;
}

=head1 AUTHOR

Chase Whitener << <cwhitener at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-e4se at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-E4SE>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc WebService::E4SE


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-E4SE>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-E4SE>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-E4SE>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-E4SE/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Chase Whitener.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of WebService::E4SE
