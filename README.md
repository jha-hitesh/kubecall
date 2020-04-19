# kubecall
kubecall is a bash wrapper around kubectl (kubernetes management command line), which provides simpler ways to access k8 resources with minimal user interaction.

## Idea
The idea behind kubecall is provide one liner commands to perform daily kubernetes action, **kubecall** achieves this by merging context switching and resource interaction commands together in same line coupled with cached suggessions for context and deployment patterns. I comes in handly when there are mutiple context available such as (development, staging, prodcution) and we quickly need to interact between pods of different context.

## Getting Started

### Prerequisites
A working kubernetes setup and `kubectl` installed.

### Installing
* Run `setup.sh add` with root privilages. (`sudo bash setup.sh add`)
* The setup will list down all the available kubernetes contexts.
* Select/deselect contexts for which you want to enable autocompletion feature
* Restart bash

## Supported commands
Kubecall supports all the built-in kubectl commands out of the box and provides few additional of it's own.

To run any buil-in kubectl commands just write them as you would do with kubectl, the only difference being `kubecall` at the start instead of `kubectl`
* eg. `kubecall get pods`, `kubectl get pods | grep my-service`, `kubectl logs -f myservice-pod` etc.

These are the additional commands which kubecall adds.

* `current-context-kc` : displays currently selected context

* `list-context-kc` : displays list of available contexts with additional option to select one of them using thier numerical position in the list. 
                                      
* `switch-context-kc` `<context_name>`  : switches to context name provided, if the context name is not provided or provided wrong, list of contexts is presented for selection using thier numerical position in list. user can press `<tab>` twice to get suggessions for context names.
 
* `list-pods` `<context_name>` `<deployment_pattern>`  : presents list of pods under given context name with pod names matching given  deployment pattern. both context name and deployment pattern can be chosen from suggessions by pressing `<tab>` twice.

* `logs-kc` `<context_name>` `<deployment_pattern>` : fetches logs of a pod identified by deployment pattern in given context name, if more than 1 pod matching the pattern is found, matched pod list is presented with option to select one of them by thier numerical position. besides above few more arguments can be added at end such as `follow` or `tail <log_count>`. by default it will follow logs, in tail mode default log count is 500.

* `execute-kc` `<context_name>` `<deployment_pattern>` `<executable_cmd>` : executes given executable cmd on a pod identified by given deployment pattern in given context. if more than one matching pod is found then a list is presented to choose from.

* `execute-all-kc` `<contAuthorsext_name>` `<deployment_pattern>` `<executable_cmd>` : works same as above except if more than 1 pod is found command is executed on all of them. might be useful for cache invalidation cases.

## Running the tests

## Built With
* bash : https://www.gnu.org/software/bash/

## Contributing
Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning
We use <a href="https://semver.org/">SemVer</a> for versioning. For the versions available, see the tags on this repository.

## Authors
* Hitesh Jha

* See also the list of contributors who participated in this project.

## License
This project is licensed under the MIT License - see the LICENSE.md file for details

## Acknowledgments


## Future enhancements
The idea is to create more such wrapper commands around such handy workflows.
