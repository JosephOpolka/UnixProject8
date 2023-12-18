#!/usr/bin/perl
# Project 8 - Perl 2 - Joseph Opolka
use strict;
use warnings;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
# Make sure Archive::Zip is installed, download in terminal using "cpan Archive::Zip"

my @deleted_users;

#     IMPORTANT NOTE - For deeper explaination of code sections,
#     refer to the corresponding numbered section in the Word document
#     included in this repository.


sub archive_user {
	# 1 - Archiving User Data from Directory Path
    my ($user_directory) = @_;

    my $zip = Archive::Zip->new();
    my $member = $zip->addTree($user_directory, $user_directory);
    $member->desiredCompressionLevel(COMPRESSION_LEVEL_BEST_COMPRESSION);
    
    unless ($zip->writeToFileNamed("$user_directory.zip") == AZ_OK) {
        die "Error creating $user_directory archive - " . $zip->errorString;
    }
    
    print "User directory has been archived.\n";
    push @deleted_users, $user_directory;
}

sub delete_user {
    my ($username) = @_;
    remove_tree($username);
    
    print "User directory has been deleted.\n";
}

sub report {
    # 2 - Deleted User Report
    print "\n** Deleted Users **\n";
    
    foreach my $user (@deleted_users) {
        my ($username) = $user =~ m|/([^/]+)$|;
        my $zip_locate = "$username.zip";
        print "Username - $username\n";
        print "ZIP Location - $zip_locate\n\n";
    }
}

sub main {
    while (1) {
        print "Please Select Objective - \n";
        print "[Archive & Delete User - 1]\n";
        print "[Exit Program (Display Deleted Users) - 2]\n";
        
        my $option = <STDIN>;
        chomp($option);
        
        if ($option == 1) {
            print "Please specify user directory path (format as /home/username) - ";
            my $user_directory = <STDIN>;
            chomp($user_directory);
            
            # 3 - Prompting directory pathway
            if ($user_directory =~ /^\/home\/\w+$/) {
            	archive_user($user_directory);
            	delete_user($user_directory);
            	
            	print "User data archived and deleted successfully.\n";
        	} else {
        		print "Invalid input (format as /home/username\n)"
			}
			
        } elsif ($option == 2) {
        	report();
        	print "Are you sure you want to exit? (y/n): ";
            my $confirm = <STDIN>;
            chomp($confirm);
            
            if (lc($confirm) eq 'y') {
                last;
            }
            elsif (lc($confirm) eq 'n') {
                
            } else {
            	print "Selection Invalid\n";
			}
        } else {
            print "Selection Invalid\n";
        }
    }
}

main();