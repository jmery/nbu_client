pkg_name=nbu_client
pkg_origin=jmery
pkg_version="8.1.0"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("Apache-2.0")
pkg_source="https://s3.amazonaws.com/jmery/nbu/${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum="e37f0b5f9e032cd87c7b43fa1b0a38054561695eb10940ecb37b4e3b5ce0a3ac"
# pkg_deps=(core/grep core/shadow core/bash core/glibc core/rpm core/coreutils)
pkg_build_deps=(core/busybox-static core/cpio)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_svc_user="root"
pkg_svc_group="$pkg_svc_user"
pkg_description="NetBackup Client ${pkg_version}"

# do_download() {
  # Example of downloading from a secure S3 bucket. Requires `core/aws-cli` in pkg_build_deps.
  # Download expects that you have your AWS credentials as an environment variable in the studio:
  # export AWS_ACCESS_KEY_ID=<YOUR KEY ID>
  # export AWS_SECRET_ACCESS_KEY=<YOUR SECRET KEY>

  # if [ ! -f $HAB_CACHE_SRC_PATH/$pkg_filename ]; then
  #  aws s3 cp $pkg_source "$HAB_CACHE_SRC_PATH/$pkg_filename"
  # fi
# }

do_build() {
  # Use rpm2cpio & cpio to extract the files from the rpms
  for PACKAGE in $(ls $HAB_CACHE_SRC_PATH/*.rpm); do
    rpm2cpio $PACKAGE | cpio -idmv
  done
}

do_install() {

  # copy over all the entire /usr & /etc trees from cache into the package
  cp -r $HAB_CACHE_SRC_PATH/$pkg_dirname/* $pkg_prefix/

}