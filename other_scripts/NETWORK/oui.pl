#!/usr/bin/env perl
# MAC address OUI checker
# Thijs (Thice) Bosschert
# http://www.thice.nl
# v0.4 25-06-2010
 
#$ouifile = "/usr/local/etc/aircrack-ng/airodump-ng-oui.txt";
$ouifile = "/var/lib/ieee-data/oui.txt";
 
# Print header
print "\n  MAC address OUI checker v0.4\n".
        "  by Thijs (Thice) Bosschert\n\n";
 
# Check if argument has been given
if (!$ARGV[0]) {
        fatal_error();
}
 
# Removing seperators from MAC address and uppercase chars
my $OUI = uc($ARGV[0]);
$OUI =~ s/[^0-9A-F]//g;
 
# Get OUI from MAC
if ($OUI =~ /^([0-9A-F]{6})/) {
        $OUI = $1;
        print "  Checking OUI: ".$OUI."\n";
} else {
        fatal_error();
}
 
# Open OUI file from aircrack-ng
open(my $fh, "<", $ouifile) || die "  Error: Can not access OUI file: $ouifile";
while (<$fh>) {
        ($checkoui,$company) = split(/\(hex\)/,$_);
        $checkoui =~ s/[-|\s]//g;
        # Check if OUI can be found in the list
        if ($OUI eq $checkoui) {
                $company =~ s/\t//g;
                chomp($company);
                # Output found OUI
                print "  Found OUI: ".$OUI." - ".$company."\n\n";
                exit;
        }
}
close($fh);
 
# Show if OUI was not found
print "  Could not find OUI: ".$OUI."\n\n";
 
# Error messages
sub fatal_error {
 
        print "  Error: No MAC address or OUI specified or could not recognize it.\n";
        if ($0 =~ /^\/bin\/(.*)/) {
                print "  Usage: $1 \n";
        } else {
                print "  Usage: perl $0 \n";
        }
        print "  MAC can be submitted as:\n".
                "                001122334455\n".
                "                00:11:22:33:44:55\n".
                "                00-11-22-33-44-55\n".
                "        OUI can be submitted as:\n".
                "                001122\n".
                "                00:11:22\n".
                "                00-11-22\n\n";
        exit;
}
