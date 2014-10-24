--[[
	Project: SourceMode
	Version: 1.0
	Last Edited: 24/10/2014 (Jack)
	Authors: Jack
]]--

-- Let's start off by adding our custom events that we'll need for later.
addEvent("onPlayerAttemptLogin",true)
addEvent("onPlayerAttemptRegister",true)
addEvent("onPlayerAttemptRecovery",true)

-- Setup some variables and tables we'll need.
local REGISTER_WAITTIME = 60 -- Registration limit between account registrations (to prevent players making multiple accounts quickly).

-- Setup some pre-definers since we'll be using custom functions
local _logIn = logIn

function logIn(username,password,encrypted,remember)
	--Handle the login crap here
end
addEventHandler("rp

function register(username,password,email)
	--Handle the register crap here
end

function recover(username,email)
	--Handle recovery crap here
end