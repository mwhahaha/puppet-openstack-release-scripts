# we only touch openstack dependencies
def openstackdep(f): f | test("openstack");

# capture and extract the version information from the string
def capture_ver(f): f|
   capture("(?<direction>[<>=]+)(?<ver>[0-9.]+)");

# write out our json version object
def write_ver(f): f|
   [.direction, .ver] | add;

# split the string out and convert it to an array of numbers
def split_ver(f): f|
   split(".") | map(.|tonumber);

# join the array of version numbers back to a string
def join_ver(f): f|
   map(.|tostring) | join(".");

# do a minor release bump, assumes 3 parts
def up_minor(f): f|
   [.[0],.[1]+1,.[2]];

# bump the lower version in the version requirement with a minor bump
def version_requirement_minor_bump(f): f |
  split(" ") |
  .[0] as $l |
  .[1] as $u |
  capture_ver($l) as $lower_ver |
  capture_ver($u) as $upper_ver |
  { "direction": $lower_ver.direction, "ver": join_ver(up_minor(split_ver($lower_ver.ver))) } as $new_lower_ver |
  [write_ver($new_lower_ver), write_ver($upper_ver)] | join(" ");

# jq to increase our version number and the dependencies
.["version"] as $our_version |
.["version"] = join_ver(up_minor(split_ver($our_version))) |
.dependencies |= map(.version_requirement as $ver |
  if openstackdep(.name) then
    {"name": .name, "version_requirement": version_requirement_minor_bump($ver)}
  else
    .
  end)
