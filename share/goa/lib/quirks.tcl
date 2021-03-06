if {[using_api libc]} {

	set libc_include_dir [file join [api_archive_dir libc] include]

	lappend include_dirs [file join $libc_include_dir libc]
	lappend include_dirs [file join $libc_include_dir libc-genode]

	if {$arch == "x86_64"} {
		lappend include_dirs [file join $libc_include_dir spec x86    libc]
		lappend include_dirs [file join $libc_include_dir spec x86_64 libc]
	}
}

if {[using_api stdcxx]} {

	set stdcxx_include_dir [file join [api_archive_dir stdcxx] include]

	lappend include_dirs [file join $stdcxx_include_dir stdcxx]
	lappend include_dirs [file join $stdcxx_include_dir stdcxx std]
	lappend include_dirs [file join $stdcxx_include_dir stdcxx c_global]
}

if {[using_api sdl]} {

	# CMake's detection of libSDL expects the library named uppercase
	set symlink_name [file join $abi_dir SDL.lib.so]
	if {![file exists $symlink_name]} {
		file link -symbolic $symlink_name "sdl.lib.so" }

	# search for headers in the inlude/SDL sub directory
	set sdl_include_dir [file join [api_archive_dir sdl] include SDL]
	lappend include_dirs $sdl_include_dir

	# bring CMake on the right track to find the headers and library
	lappend cmake_quirk_args "-DSDL_INCLUDE_DIR=$sdl_include_dir"
	lappend cmake_quirk_args "-DCMAKE_SYSTEM_LIBRARY_PATH='$abi_dir'"
	lappend cmake_quirk_args "-DSDL_LIBRARY:STRING=':sdl.lib.so'"
}

if {[using_api curl]} {

	if {$arch == "x86_64"} {
		lappend include_dirs [file join [api_archive_dir curl] src lib curl spec 64bit curl]
	}
}
