## no critic: TestingAndDebugging::RequireUseStrict
package Require::HookChain::source::dzil_build;

use strict;
use warnings;
use Log::ger;

# AUTHORITY
# DATE
# DIST
# VERSION

use Require::Hook::Source::DzilBuild;

sub new {
    my ($class, $zilla) = @_;
    $zilla or die "Please supply zilla object";
    bless { zilla => $zilla }, $class;
}

sub Require::HookChain::source::dzil_build::INC {
    my ($self, $r) = @_;

    my $filename = $r->filename;

    # safety, in case we are not called by Require::HookChain
    return () unless ref $r;

    if (defined $r->src) {
        log_trace "[RHC:source::dzil_build] source code already defined for $filename, declining";
        return;
    }

    my $rh = Require::Hook::Source::DzilBuild->new(zilla => $self->{zilla});
    my $res = Require::Hook::Source::DzilBuild::INC($rh, $filename);
    return unless $res;
    $r->src($$res);
}

1;
# ABSTRACT: Load module source code from Dist::Zilla build files

=for Pod::Coverage .+

=head1 SYNOPSIS

In your L<Dist::Zilla> plugin, e.g. in C<munge_files()>:

 sub munge_files {
     my $self = shift;

     local @INC = @INC;
     require Require::HookChain;
     Require::HookChain->import('source::dzil_build', $self->zilla);

     require Foo::Bar; # will be searched from build files, if exist

     ...
 }


=head1 DESCRIPTION


=head1 SEE ALSO

L<Require::Hook::Source::DzilBuild>, the L<Require::Hook> (non-chainable)
version of us.

L<Require::HookChain>
