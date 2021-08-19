package MirrorRepos;

use v5.10;
use strict;
use warnings;

use YAML::Tiny;
use Getopt::Long;
use TraverseDirectory;

require Exporter;

our @ISA = qw(Exporter);

our $VERSION = '0.01';

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use MirrorRepos ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
    parse_cfg_file
    run_download
    verify_mirrored
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( parse_cfg_file run_download verify_mirrored );


my %REPOSITORIES;
my %DOWN_METHODS;
my %VERIFY_METHODS;

=pod

=head1 NAME

MirrorRepos - Perl extension for mirroring a bunch of software repositories, for instance CentOS or epel, via lftp or
other pluggable downloader. After this verify checksum on all packages and repo meta data files using rpm/yum or
pluggable verifyer.

=head1 SYNOPSIS

  _use MirrorRepos;

  #load config file to $cfg_file
  parse_cfg_file( $cfg_file );
  run_download();
  verify_mirrored();

=head1 DESCRIPTION

Download and verify various repos for your own local mirrors.

=head2 EXPORT

None by default.

=head1 GENERIC METHODS

=over

=item parse_cfg_file

=cut

sub parse_cfg_file {
    my $cfg_file = shift;
    chomp $cfg_file;
    # Open the config
    my $yaml = YAML::Tiny->read( $cfg_file );
    # Get a reference to the first document
    my $config = $yaml->[0];
    %REPOSITORIES   = _get_repos($config);
    %DOWN_METHODS   = _get_down_methods($config);
    %VERIFY_METHODS = _get_verify_methods($config);
}

=item run_download

=cut

sub run_download {
    # loop over the repositories hash and download the respective repositories (later try to parallelize it)
    for my $repo (keys %REPOSITORIES){
        my $method = $REPOSITORIES{$repo}->{'DownloadMethod'};
        my @urls = @$REPOSITORIES{$repo}->{'DownloadUrl'};
        my @excludelist = @$REPOSITORIES{$repo}->{'ExcludeDirs'};
        my $cmd = $DOWN_METHODS{$method}->{'ExecPath'};
        my $xcld_mark = $DOWN_METHODS{$method}->{'ExcludeArgument'};
        my @arglist = @$DOWN_METHODS{$method}->{'Arguments'};
        my $excludes = join "$xcl_mark", @exludelist;
        $excludes = "$xcl_mark $excludes";
        my $args = join ' ', @arg_list;
        say "$cmd $args $excludes $url";
    }
}

=head3 verify_mirrored

=cut

sub verify_mirrored {
    # loop over repositories and verify that all is ok, then print a report.
    for my $repo (keys %REPOSITORIES){
        my $method = $REPOSITORIES{$repo}->{'Verification'}->{'Method'};
        my $path = $REPOSITORIES{$repo}->{'LocalStorage'};
    }
}


# Preloaded methods go here.

sub _get_repos {
    my $cfg = shift;
    # get repositories hash;
    my %conf = %$cfg;
    my $reposref = $conf{Repositories};
    return %$reposref;
}

sub _get_down_methods {
    my $cfg = shift;
    # get every possible download from repo definitions
    # get download definitions from definitions section
    # Check if a download method is missing
    my %conf = %$cfg;
    my $dwlref = $cfg{'Definitions'}->{'Download'};
    return %$dwlref;
}

sub _get_verify_methods {
    my $cfg = shift;
    # get every possible verification from repo definitions
    # get verification definitions from definitions section
    # Check if a verification method is missing
    my %conf = %$cfg;
    my $verref = $cfg{'Definitions'}->{'Verification'};
    return %$dwlref;
}


1;
__END__

=head1 AUTHOR

Robert Lilja, E<lt>rlilja@(none)E<gt>


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2021 by Robert Lilja

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.32.1 or,
at your option, any later version of Perl 5 you may have available.






