#!/usr/bin/env bash

# Copyright (C) 2021 Square, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under
# the License.

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