{{ range ls "users" }}
        {{ $userState := .Value }}
        {{ $user := .Key }}
        echo Processing user {{ $user }}
        {{if (eq $userState "deleted")}}
        echo Deleting user {{ $user }}
	userdel {{$user}}
        {{end}}
        {{if (eq $userState "enabled")}}
        echo creating/updating user {{ $user }}
                        {{ if keyExists (print "users/" $user "/userid") }}
                        {{ if keyExists (print "users/" $user "/groupid") }}
                                USERNAME={{$user}}
                                USERID={{ key (print "users/" $user "/userid") }}
                                {{ $groupid := (key (print "users/" $user "/groupid")) }}
				
				{{ if keyExists (print "group/" $groupid "/name") }}
                                GROUPNAME={{ key (print "group/" $groupid "/name") }}
                                groupadd -g {{$groupid}} $GROUPNAME
                                {{ end }}
				
				userdel $USERNAME
                                
                                useradd -g {{$groupid}} -u $USERID -d /home/$USERNAME $USERNAME

                        {{ end }}
                        {{ end }}
        {{end}}

{{ end }}

