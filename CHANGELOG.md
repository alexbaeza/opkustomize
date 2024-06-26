# [1.3.0](https://github.com/alexbaeza/opkustomize/compare/v1.2.3...v1.3.0) (2024-04-14)


### Features

* **path-copy:** Make script copy everything from root folder to be able to support kustomize overlays, add --dry-run flag to supportpiping the output to other tools like kubeconform ([9b8c0be](https://github.com/alexbaeza/opkustomize/commit/9b8c0be50961b1d219cae2d0e34a585d03a77c33))

## [1.2.3](https://github.com/alexbaeza/opkustomize/compare/v1.2.2...v1.2.3) (2024-04-13)


### Bug Fixes

* Fixes paths and removes debug logs ([9c1d6db](https://github.com/alexbaeza/opkustomize/commit/9c1d6db042b03c4303092e2e11a2f8ca2eaae7b3))

## [1.2.2](https://github.com/alexbaeza/opkustomize/compare/v1.2.1...v1.2.2) (2024-04-13)


### Bug Fixes

* **path-copy:** Make script copy eveything from root folder to be able to support kustomize overlays ([f7bbbda](https://github.com/alexbaeza/opkustomize/commit/f7bbbda85e5d781b92f278f0e256fdf05af0e09d))

## [1.2.1](https://github.com/alexbaeza/opkustomize/compare/v1.2.0...v1.2.1) (2024-04-13)


### Bug Fixes

* **enhancement:** Remove logs as it conflictsand creates an issue when piping the output to other tools such as kubeconform ([fde5199](https://github.com/alexbaeza/opkustomize/commit/fde51999257118ba1f690330810dfb91674bca07))

# [1.2.0](https://github.com/alexbaeza/opkustomize/compare/v1.1.0...v1.2.0) (2024-04-13)


### Features

* **enhancement:** Add --dry-run flag that does not run and replace env vars ([1665090](https://github.com/alexbaeza/opkustomize/commit/166509002dd747e8b97ae33ec99186d2cd780001))

# [1.1.0](https://github.com/alexbaeza/opkustomize/compare/v1.0.0...v1.1.0) (2024-04-13)


### Features

* **enhancement:** Add argument validation to ensure calling the tool with no commands displays the help message ([78ae493](https://github.com/alexbaeza/opkustomize/commit/78ae493b4f191506967a88d307ba3a02e51dec21))

# 1.0.0 (2024-04-13)


### Features

* OpKustomize is a Bash script that facilitates the injection of secrets and environment variable substitution using ([5590c4e](https://github.com/alexbaeza/opkustomize/commit/5590c4e75890101759b964ec9e347476cc1fb945))
