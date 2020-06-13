# kubecall
kubecall is a bash wrapper around kubectl (kubernetes management command line), which tries to provide one liner ways to interact k8 resources.

## Inspiration
* The inspiration for **kubecall** came to solve the daily kubernetes workflows which are generally two steps. A multi clustor enviornment running diverse set of pods usually demands context switching for almost every pod interaction.
**kubecall** solves this by merging context switching and resource interaction commands together in same line coupled with autocompleton for context names and deployment names.

## Getting Started

### Prerequisites
A working kubernetes setup and `kubectl` installed.

### Installing
* Run `./setup.sh add` or `bash setup.sh add`.
* The setup will list down all the available kubernetes contexts.
* Select/deselect contexts for which you want to enable autocompletion feature
* you will be asked for your password as installation requires access `/usr/local/bin/` folder.
* Restart bash

## Supported commands
Kubecall supports all the built-in kubectl commands out of the box and provides few additional of it's own.

To run any built-in kubectl commands just write them as you would do with kubectl, the only difference being `kubecall` at the start instead of `kubectl`
* eg. `kubecall get pods`, `kubectl delete pod myservice-pod`, `kubectl logs -f myservice-pod` etc.

Adds following command chain:
* `context current` displays current context
* `context list` displays list of contexts
* `context switch <context_name>` switches to given context
* `execall <deployment_pattern> <CMD>` with optional `--context=<context_name>` executes given command on all the pods matching deployment_pattern after confirmation.

modifies a set of commands with given syntax.
* `logs <deployment_pattern>` with optional `--context=<context_name>` and `--json` and one of (`-f`, `--follow`, `--tail=<log_count>`)
* `exec <deployment_pattern> <CMD>` with optional `--context=<context_name>` and one of (`-i`, `-t`, `-it`)
* `describe <deployment_pattern>` with optional `--context=<context_name>`
* `get pods <deployment_pattern>` with optional `--context=<context_name>`
* `delete <deployment_pattern>` with optional `--context=<context_name>` deletes pods matching given pattern after selection and confirmation.

In any command press tab twice to get suggestion for context_name and deployment_pattern or simply for next command.

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
* add auto completion for all existing kubectl commands.
