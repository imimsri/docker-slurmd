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
				userdel $USERNAME
                                groupadd -g $USERID $USERNAME
                                useradd -g $USERID -u $USERID -d /home/$USERNAME $USERNAME

                        {{ end }}
                        {{ end }}
        {{end}}

{{ end }}

