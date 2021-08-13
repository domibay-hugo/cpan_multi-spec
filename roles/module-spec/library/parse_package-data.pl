#!/usr/bin/perl

# @author Bodo (Hugo) Barwich
# @version 2021-08-02
# @package RPM Packaging for Perl
# @subpackage parse_package-data.pl

# This Module parses the Package Dependencies from the distributed META Files
#
#---------------------------------
# Requirements:
# - The Perl Package "perl-Data-Dump" must be installed
# - The Perl Package "perl-YAML" must be installed
# - The Perl Package "perl-JSON" must be installed
# - The Perl Package "perl-Path-Tiny" must be installed
#
#---------------------------------
# Configurations:
# -r=\"{{ release }}\" --dir=\"{{ source_directory }}\""
#
#---------------------------------
# Features:
#



#==============================================================================
# Exectuting Section


use warnings;
use strict;

use Data::Dump qw(dump);

use JSON;
use YAML;
use Path::Tiny;



#-------------------------------------
#Read the Script Parameters

my $srqpkg = '';
my $srqrel = '';
my $srqmndir = '';

my $iqt = 0;
my $idbg = 0;


if(scalar(@ARGV) > 0)
{
  my $sargky = '';
  my $sargvl = '';


  foreach (@ARGV)
  {
    #print "arg: '$_'\n";

    if(index($_ , '--') == 0)
    {
      #print "prm dsh: '$_'\n";

      $srqpkg = '' if($srqpkg eq 'p');
      $srqrel = '' if($srqrel eq 'r');
      $srqmndir = '' if($srqmndir eq 'd');

      ($sargky, $sargvl) = split(/=/, $_ , 2);

      $sargky = lc substr($sargky, 2);

      #print "prm dsh 1: ky '$sargky'; vl: '"; print $sargvl if(defined $sargvl); print "'\n";

      if($sargky eq 'package')
      {
        $srqpkg = 'p';
      }
      elsif($sargky eq 'release')
      {
        $srqrel = 'r';
      }
      elsif($sargky =~ qr/(main-)?dir(ectory)?/)
      {
        $srqmndir = 'd';
      } #if($sargky eq 'users')

      if(defined $sargvl)
      {
        #The Parameter has an Equal Sign

        if($srqpkg eq 'p')
        {
          $srqpkg = $sargvl;
        }
        elsif($srqrel eq 'r')
        {
          $srqrel = $sargvl;
        }
        elsif($srqmndir eq 'd')
        {
          $srqmndir = $sargvl;
        } #if($srqrel eq 'r')
      } #if(defined $sargvl)
    }
    elsif(index($_ , '-') == 0)
    {
      #print "prm dsh: '$_'\n";

      $srqpkg = '' if($srqpkg eq 'p');
      $srqrel = '' if($srqrel eq 'r');
      $srqmndir = '' if($srqmndir eq 'd');

      ($sargky, $sargvl) = split(/=/, $_ , 2);

      $sargky = lc substr($sargky, 1);

      #print "prm dsh 1: ky '$sargky'; vl: '"; print $sargvl if(defined $sargvl); print "'\n";

      while($sargky =~ /(.)/g)
      {
        if($1 eq 'p')
        {
          $srqpkg = 'p';
        }
        elsif($1 eq 'r')
        {
          $srqrel = 'r';
        }
        elsif($1 =~ qr/[qb]/)
        {
          $iqt = 1;
        }
        elsif($1 =~ qr/[dv]/)
        {
          $idbg = 1;
        }
      } #while($sarg =~ /(.)/g)

      if(defined $sargvl)
      {
        #The Parameter has an Equal Sign

        if($srqpkg eq 'p')
        {
          $srqpkg = $sargvl;
        }
        elsif($srqrel eq 'r')
        {
          $srqrel = $sargvl;
        }
      } #if(defined $sargvl)
    }
    else  #The Parameter does not have a Dash Sign
    {
      #print "prm any: '$_'\n";

      if($_ =~ qr/^-?\d+$/)
      {
        #The Parameter is a Number
      }
      else  #The Parameter isn't a Number
      {
        #Parameter any Value

        if($srqpkg eq 'p')
        {
          $srqpkg = $_ ;
        }
        elsif($srqrel eq 'r')
        {
          $srqrel = $_ ;
        }
        elsif($srqmndir eq 'd')
        {
          $srqmndir = $_ ;
        } #if($srqrel eq 'r')
      } #if($_ =~ qr/^-?\d+$/)
    }  #if(index($sarg, "-") == 0)
  }  #foreach $sarg (@ARGV)
}  #if(scalar(@ARGV) > 0)

if($idbg > 0
  && $iqt < 1)
{
  print "rq pkg: '$srqpkg'; rq rel: '$srqrel'; rq dir: '$srqmndir'\n";
  print "qt: '$iqt'; dbg: '$idbg'\n";
} #if($idbg > 0 && $iqt < 1)

$srqmndir .= '/' unless($srqmndir =~ qr#/$#);


#-------------------------------------
#Parse the Package Build Configuration

my $rhshpkgcnf = undef;
my %hshrscnf = ($srqpkg => {'builder' => '', 'arch' => 'noarch'});

my $spkgdir = $srqmndir . $srqrel;
my $ixscnt = 0;

my $ierr = 0;


$spkgdir .= '/' unless($spkgdir =~ qr#/$#);

unless(-d $spkgdir)
{
  print STDERR "Package '$srqpkg': Source Directory '$spkgdir' does not exist!\n";

  exit 2;
} #unless(-d $spkgdir)

unless(chdir $spkgdir)
{
  print STDERR "Package '$srqpkg': Source Directory '$spkgdir' cannot be opened!\n";

  exit 1;
}

if(-f 'Makefile.PL')
{
  $hshrscnf{$srqpkg}{'builder'} = 'make';
}
elsif(-f 'Build.PL')
{
  $hshrscnf{$srqpkg}{'builder'} = 'build';
}

$ixscnt = `find ./ -name "*.xs" | wc -l`;

chomp $ixscnt;

$ixscnt = 0 if($ixscnt eq '');

$hshrscnf{$srqpkg}{'arch'} = 'x86_64' if($ixscnt);

if(-f 'META.yml')
{
  $rhshpkgcnf = YAML::LoadFile('META.yml');
}
elsif(-f 'META.json')
{
  $rhshpkgcnf = JSON::decode_json(path('META.yml')->slurp);
}

if($idbg > 0
  && $iqt < 1)
{
  print "pkg cnf in 0 dmp:\n" . dump($rhshpkgcnf); print "\n";
}

$hshrscnf{$srqpkg}{'release.version'} = $rhshpkgcnf->{'version'};
$hshrscnf{$srqpkg}{'distribution'} = $rhshpkgcnf->{'name'};
$hshrscnf{$srqpkg}{'summary'} = $rhshpkgcnf->{'abstract'};
$hshrscnf{$srqpkg}{'requires'}{'build'} = [];
$hshrscnf{$srqpkg}{'requires'}{'runtime'} = [];
$hshrscnf{$srqpkg}{'recommends'} = [];
$hshrscnf{$srqpkg}{'provides'} = [];

if(defined $rhshpkgcnf->{'prereqs'})
{
  #------------------------
  #Parse JSON Structure

  if(defined $rhshpkgcnf->{'prereqs'}->{'build'}
    && defined $rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'}})
    {
      push @{$hshrscnf{$srqpkg}{'requires'}{'build'}}, ({'feature' => $_
        , 'version' => $rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'build'}
    # && defined $rhshpkgcnf->{'prereqs'}->{'build'}->{'requires'})

  if(defined $rhshpkgcnf->{'prereqs'}->{'configure'}
    && defined $rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'}})
    {
      push @{$hshrscnf{$srqpkg}{'requires'}{'build'}}, ({'feature' => $_
        , 'version' => $rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'configure'}
    # && defined $rhshpkgcnf->{'prereqs'}->{'configure'}->{'requires'})

  if(defined $rhshpkgcnf->{'prereqs'}->{'test'}
    && defined $rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'}})
    {
      push @{$hshrscnf{$srqpkg}{'requires'}{'build'}}, ({'feature' => $_
        , 'version' => $rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'test'}
    # && defined $rhshpkgcnf->{'prereqs'}->{'test'}->{'requires'})

  if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'})
  {
    if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'})
    {
      foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'}})
      {
        push @{$hshrscnf{$srqpkg}{'requires'}{'runtime'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'}->{$_}});
      }
    } #if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'}
      # && defined $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'requires'})

    if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'recommends'})
    {
      foreach (keys %{$rhshpkgcnf->{'prereqs'}->{'runtime'}->{'recommends'}})
      {
        push @{$hshrscnf{$srqpkg}{'recommends'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'prereqs'}->{'runtime'}->{'recommends'}->{$_}});
      }
    } #if(defined $rhshpkgcnf->{'recommends'})
  } #if(defined $rhshpkgcnf->{'prereqs'}->{'runtime'})
}
else  #Package does not have the 'prereqs' Structure
{
  #------------------------
  #Parse YAML Structure

  if(defined $rhshpkgcnf->{'build_requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'build_requires'}})
    {
      push @{$hshrscnf{$srqpkg}{'requires'}{'build'}}, ({'feature' => $_
        , 'version' => $rhshpkgcnf->{'build_requires'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'build_requires'})

  if(defined $rhshpkgcnf->{'configure_requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'configure_requires'}})
    {
      push @{$hshrscnf{$srqpkg}{'requires'}{'build'}}, ({'feature' => $_
        , 'version' => $rhshpkgcnf->{'configure_requires'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'configure_requires'})

  if(defined $rhshpkgcnf->{'requires'})
  {
    foreach (keys %{$rhshpkgcnf->{'requires'}})
    {
      push @{$hshrscnf{$srqpkg}{'requires'}{'runtime'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'requires'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'requires'})

  if(defined $rhshpkgcnf->{'recommends'})
  {
    foreach (keys %{$rhshpkgcnf->{'recommends'}})
    {
      push @{$hshrscnf{$srqpkg}{'recommends'}}, ({'feature' => $_
          , 'version' => $rhshpkgcnf->{'recommends'}->{$_}});
    }
  } #if(defined $rhshpkgcnf->{'recommends'})
} #if(defined $rhshpkgcnf->{'prereqs'})

if(defined $rhshpkgcnf->{'provides'})
{
  foreach (keys %{$rhshpkgcnf->{'provides'}})
  {
    push @{$hshrscnf{$srqpkg}{'provides'}}, ({'feature' => $_
        , 'version' => $rhshpkgcnf->{'provides'}->{$_}->{'version'}});
  }
} #if(defined $rhshpkgcnf->{'configure_requires'})

if($idbg > 0
  && $iqt < 1)
{
  print "pkg cnf 1 dmp:\n" . dump(%hshrscnf) ; print "\n";
}


#-------------------------------------
#Report the Package Configuration Result

print encode_json \%hshrscnf;


#Communicate Error Code
exit $ierr;
