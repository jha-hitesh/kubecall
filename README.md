# kubecall
kubecall is a bash wrapper around kubectl (kubernetes management command line), which tries to provide one liner ways to interact k8 resources.

## Inspiration
* The inspiration for **kubecall** came to solve the daily kubernetes workflows which are generally two steps. A multi clustor enviornment running diverse set of pods usually demands context switching for almost every pod interaction.
**kubecall** solves this by merging context switching and resource interaction commands together in same line coupled with autocomplete for context names and deployment names.

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

To run any built-in kubectl commands just write them as you would do with kubectl, the only difference being `kubecall` at the start instead of `kubectl`
* eg. `kubecall get pods`, `kubectl get pods | grep my-service`, `kubectl logs -f myservice-pod` etc.

These are the additional commands which kubecall adds.

* `current-context` : displays currently selected context

* `list-context` : displays list of available contexts with additional option to select one of them using thier numerical position in the list.

* `switch-context` `<context_name>`  : switches to context name provided, if the context name is not provided or provided wrong, list of contexts is presented for selection using thier numerical position in list. user can press `<tab>` twice to get suggessions for context names.

* `list-pods` `<context_name>` `<deployment_pattern>`  : presents list of pods under given context name with pod names matching given  deployment pattern. both context name and deployment pattern can be chosen from suggessions by pressing `<tab>` twice.

* `show-logs` `<context_name>` `<deployment_pattern>` : fetches logs of a pod identified by deployment pattern in given context name, if more than 1 pod matching the pattern is found, matched pod list is presented with option to select one of them by thier numerical position. besides above few more arguments can be added at end such as `follow` or `tail <log_count>`. by default it will follow logs, in tail mode default log count is 500.

* `execute-cmd` `<context_name>` `<deployment_pattern>` `<executable_cmd>` : executes given executable cmd on a pod identified by given deployment pattern in given context. if more than one matching pod is found then a list is presented to choose from.

* `execute-cmd-all` `<context_name>` `<deployment_pattern>` `<executable_cmd>` : works same as above except if more than 1 pod is found command is executed on all of them. might be useful for cache invalidation cases.

## Running the tests
* will be added

## Built With
* bash : https://www.gnu.org/software/bash/
* kubectl : https://kubernetes.io/docs/reference/kubectl/overview/

## Contributing
Please read <a href="https://github.com/jha-hitesh/kubecall/blob/master/CONTRIBUTING.md">CONTRIBUTING.md</a> for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning
We use <a href="https://semver.org/">SemVer</a> for versioning. For the versions available, see the tags on this repository.

## Authors
* Hitesh Jha

* See also the list of contributors who participated in this project.

## License
This project is licensed under the MIT License - see the <a href="https://github.com/jha-hitesh/kubecall/blob/master/LICENSE">LICENSE</a> file for details

## Acknowledgments
* will come

## Future enhancements
* Identify more such reoccuring workflow and create one liner command around the workflow.
