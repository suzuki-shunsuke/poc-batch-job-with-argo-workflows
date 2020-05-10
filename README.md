# poc-batch-job-with-argo-workflows

POC to run batch jobs with Argo Workflows

## Status

Work in progress.

## Motivation

* Run batch jobs on the Container native platform
* Manage job code with Git and develop it with pull request driven
* Manage multiple jobs in one repository

## Requirement

* [Argo Workflow](https://argoproj.github.io/projects/argo)
* CircleCI or something to run `argo submit`

## Requirement at local

* Git
* [cmdx](https://github.com/suzuki-shunsuke/cmdx)
* [GitHub CLI](https://cli.github.com/)
* fzf/peco (opitonal)

## Create a workflow

Skaffold a workflow.

```
$ cmdx s <workflow name>
```

Edit workflow

```
$ vi workflow/<workflow name>/workflow.yaml
$ vi workflow/<workflow name>/parameter.yaml
```

Commit and push to the master branch.

## Run a new job

```
$ cmdx p <workflow name>
```

This command creates and open a template file of workflow's parameter.
After edit and close this file, a pull request is created.
When the pull request is merged, `argo submit` is run and job is run with Argo Workflows.
