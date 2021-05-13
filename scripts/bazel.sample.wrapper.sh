#!/usr/bin/env bash

# Split the args into bazel specific and run-specific
bazel_args=()
runner_args=()
while (( $# > 0 )) ; do
  case "$1" in
    "--")
      runner_args+=( "--" )
      ;;
    *)
      if (( "${#runner_args[*]}" > 0 )) ; then
        runner_args+=( "$1" )
      else
        bazel_args+=( "$1" )
      fi
      ;;
  esac
  shift
done

for arg in ${bazel_args[*]} ; do
  if [[ "$arg" == --override_repository=rules_sqldelight* ]] ; then
    overriden_repository=true
    break
  fi
done

if [[ "${overriden_repository}" != true ]] ; then
  root="$(dirname "$(dirname "$(dirname "$(dirname "$0")")")")"
  binary_pkg="${root}/bazel-bin/rules_sqldelight_release.tgz"
  if [[ ! -f "${binary_pkg}" ]] ; then
    echo -n "Please either build the //:sqldelight_release_pkg in ${root} or otherwise run "
    echo "bazel with --override_repository pointing to an un-tarred release package."
    exit 1
  fi
  rules_dir=$(mktemp -d -t ci-XXXXXX)
  trap 'rm -rf "${rules_dir}"' EXIT

  echo "Expanding ${binary_pkg} to ${rules_dir}"
  tar -xzf "${binary_pkg}" -C "${rules_dir}"
  bazel_args+=("--override_repository=rules_sqldelight=${rules_dir}")

fi

# shellcheck disable=SC2086
# We want word splitting here.
"${BAZEL_REAL}" ${bazel_args[*]} ${runner_args[*]}