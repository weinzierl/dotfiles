#!/usr/bin/perl
# Ludwig Weinzierl, 2013

use strict;
use warnings;

my $gplfile='colorized.gpl';
my $styleguide='styleguide.txt';

my @color;
my %font;
my %linewidth;


# Read style guide

open(INFILE, "<", $styleguide) or die $!;
while(<INFILE>){
  chomp;
  unless(/^#/ || /^\s*$/) {
    if(/^([0-9a-f]{2} ){3}[a-z]+$/){
      my ($r, $g, $b, $n) = split(/ /);
      my $entry = {};
      $entry->{r} = $r;
      $entry->{g} = $g;
      $entry->{b} = $b;
      $entry->{n} = $n;
      push(@color, $entry);
    }

    if(/^font.([a-z]+):\s*([a-zA-Z0-9", ]+)\s*$/){
      $font{$1} = $2;
    }

    if(/^linewidth.([a-z]+):\s*(\d+.\d+) mm\s*$/){
      $linewidth{$1} = $2;
    }

  }
}

close(INFILE);

# Build various strings
$font{pango}   = "$font{monospace} $font{size}";
$font{pangoq}  = $font{pango}; $font{pangoq}  =~ s/ /\\ /g;

$font{xft}     = "xft:$font{monospace}:pixelsize=$font{size}";
$font{xft}     = $font{xft}.":antialias=$font{antialias}";
$font{xft}     = $font{xft}.":hinting=$font{hinting}";

$font{vim}     = "set guifont=$font{pangoq}";
$font{vimwin}  = $font{vim}; $font{vimwin}  =~ s/\\ (\d+)$/:h$1/g;


# Print values for debugging
foreach(keys %font){
  print "$_ -> $font{$_}\n";
}

foreach(keys %linewidth){
  print "$_ -> $linewidth{$_}\n";
}

# Process files

# GIMP color palette

local(*OUTFILE);
open(OUTFILE, "<", $gplfile) or die $!;
my $old = do{local($/); <OUTFILE>};
my $new = $old;
foreach(@color){
  my $colorentry;
  my $colorname=$_->{n};
  $colorentry .= sprintf("%d ", hex($_->{r}));
  $colorentry .= sprintf("%d ", hex($_->{g}));
  $colorentry .= sprintf("%d",  hex($_->{b}));
  $colorentry .= "\t";
  $colorentry .= $colorname;
  $new =~ s/^\d{1,3} \d{1,3} \d{1,3}\t$colorname$/$colorentry/mg;
}
close(OUTFILE);

if($old ne $new){
  print "$gplfile written.\n";
  open(OUTFILE, ">", $gplfile) or die $!;
  print OUTFILE $new;
  close(OUTFILE);
}











