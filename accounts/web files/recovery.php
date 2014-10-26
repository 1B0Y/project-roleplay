<?php
	/*
	Project: SourceMode
	Version: 1.0
	Last Edited: 26/10/2014 (Jack)
	Authors: Jack
	*/
	
	include( "mta_sdk.php" ); //Make sure you put this in the same directory of your recovery.php file.
	$input = mta::getInput(); //Get the input from the server
	
	$username = $input[0];
	$email = $input[1];
	$newPass = $input[2];
	
	if ($username && $email && $newPass)
	{
		mail($email,"SourceMode: Password Recovery","Dear "+$username+",\nAccording to our system, you have requested a password recovery. Below you'll find your new login details.\n\nUsername: "+$username+"\nPassword: "+$password+"\n\nPlease change your password information when you log in to prevent anyone guessing the new pass and gaining access.\nSourceMode.");
		mta::doReturn(true); //Return true to the script to display "Sent" on the GUI
		return true;
	} else {
		mta::doReturn(false); //ERROR!
		return false;
	}
?>