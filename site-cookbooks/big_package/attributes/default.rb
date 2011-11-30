#
# All but the most hermetic production machines benefit from certain base
# packages -- git, htop, libxml, etc -- be present. Creating a stupid one-line
# cookbook for each is overkill and clutters your runlist. Having a fixed
# 'big_dumping_ground_for_packages' is a proven disaster -- one coder's
# convenience gems is anothers' bundler hell.
#
# Package sets provide
# * visibility: I know *exactly* which miscellaneous packages are installed
# * package sets are repeatable and match the machine's purpose: dev boxes get a
#   variety of kitchen sinks, production boxes get only bare essentials.
# * Fine-grained control over versions, and ability to knock out a conflicting
#   package.
#
# The pkg_sets attribute group defines what package sets to install, and the
# contents of those package sets.
#
# Choose the package sets to install by setting `node[:pkg_sets][:install]`. The
# default is
#
#     default[:pkg_sets][:install] = %w[ base dev sysadmin ]
#
# Targets for `package` resource go in `node[:pkg_sets][:pkgs][{set_name}]`,
# targets for `gem_package` go in `node[:pkg_sets][:gems][{set_name}]`, and so
# forth. For instance, the 'base' group is defined as
#
#     default[:pkg_sets][:pkgs][:base] = %w[ tree git zip openssl ]
#     default[:pkg_sets][:gems][:base] = %w[ bundler rake ]
#
# In your clusters file or a role, you can both specify which sets (if any) the
# machine installs, and modify (for that node or role only) what packages are
# in any given group.
#
# Defining pkg_sets is distributed -- anything can define a 'foo' group by
# setting `node[:pkg_sets][:pkgs][:foo]`, no need to modify this
# cookbook. Selecting *which* packages to install is however unambiguous -- you
# must expressly add the set 'foo' to your node[:pkg_sets][:install] attribute.
#

#
# Package sets to install. Add or remove as convenience & prudence dictate.
#
default[:pkg_sets][:install]          = %w[ base dev sysadmin ]

# --------------------------------------------------------------------------
#
# Package set definitions: related code assets installable as a group
#

default[:pkg_sets][:pkgs][:base]      = %w[ tree git zip openssl ]
default[:pkg_sets][:gems][:base]      = %w[ bundler rake ]

default[:pkg_sets][:pkgs][:dev]       = %w[ emacs23-nox elinks colordiff ack exuberant-ctags ]
default[:pkg_sets][:gems][:dev]       = %w[
  activesupport activemodel extlib json yajl-ruby awesome_print addressable cheat
  yard jeweler rspec  watchr pry configliere gorillib highline formatador choice rest-client wirble hirb ]

default[:pkg_sets][:pkgs][:sysadmin]  = %w[ ifstat atop htop tree chkconfig sysstat nmap ]
default[:pkg_sets][:gems][:sysadmin]  = %w[]

default[:pkg_sets][:pkgs][:text]      = %w[ libidn11-dev libxml2-dev libxml2-utils libxslt1-dev tidy ]
default[:pkg_sets][:gems][:text]      = %w[ nokogiri erubis i18n ]

default[:pkg_sets][:pkgs][:ec2]       = %w[ s3cmd ec2-ami-tools ec2-api-tools ]
default[:pkg_sets][:gems][:ec2]       = %w[ fog right_aws ]

default[:pkg_sets][:pkgs][:vagrant]   = %w[ ifstat htop tree chkconfig sysstat htop nmap ]
default[:pkg_sets][:gems][:vagrant]   = %w[ vagrant ]

default[:pkg_sets][:pkgs][:python]    = %w[python-dev python-setuptools pythong-simplejson]

default[:pkg_sets][:pkgs][:datatools] = %w[
  r-base r-base-dev x11-apps eog texlive-common texlive-binaries dvipng
  ghostscript latex libfreetype6 python-gtk2 python-gtk2-dev python-wxgtk2.8
]


ruby_mode = (node[:languages][:ruby][:version] =~ /^1.9/ ? "ruby1.9.1-elisp" : "ruby") # rescue nil
default[:pkg_sets][:pkgs][:emacs]     = [ "emacs23-nox", "emacs23-el", "python-mode", ruby_mode, "org-mode" ].compact
