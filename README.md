# LC-MS-Pachyderm

In this page we introduce a start-to-end LC-MS-analysis workflow that you can run using [Pachyderm](https://github.com/pachyderm/pachyderm), a distributed data-processing tool built on software containers that enables scalable and reproducible pipelines.

## Prerequisites

-	A running Kubernetes cluster with Pachyderm deployed as a service. Note that this will not work on Minikube standard settings. A Cloud environment is highly desirable.
-	The Pachyderm command line tool: `pachctl` correctly configured to talk with the cluster.

Relevant sources:

-	[KubeNow GitHub](https://github.com/kubenow/KubeNow) A simplified way of deploying Kubernetes on cloud-agnostic infrastructures
-	[Pachyderm Helm Chart](https://github.com/kubernetes/charts/tree/master/stable/pachyderm) A Helm Chart for deploying Pachyderm on Kubernetes as a service
-	[Pachyderm Docs](http://docs.pachyderm.io/en/v1.7.3/index.html) Official documentation of Pachyderm
-	[PhenoMeNal VRE Plugin](https://github.com/phnmnl/KubeNow-plugin) PhenoMeNal VRE deployment as a plugin for KubeNow. This plugin includes the possibility to deploy Pachyderm as a service.


### Ingest the dataset from MetaboLights
Note that for uploading the data to the `PFS`, it is advisable to interact with Pachyderm from the master node. For reviewing purposes, the dataset can be downloaded from MetaboLights by using a authentication token.

1. Start by cloning this repository:
```bash
git clone https://github.com/pharmbio/LC-MS-Pachyderm
cd LC-MS-Pachyderm
```

2. Ingest the dataset using the provided bash scripts:

```bash
# Dataset retrieval
sh download-ms1.sh <token>
sh download-ms2.sh <token>
```

### Add the dataset to the Pachyderm File System (PFS)
Create a repo called `ms1` and push the dataset into it:

```bash
# ms1 data upload 
pushd ms1
pachctl create-repo ms1
pachctl put-file ms1 master -c -r -p 3 -f . 
popd
```

Repeat the previous procedure for the `ms2` data and the `metadata`:

```bash
# ms2 data upload 
pushd ms2
pachctl create-repo ms2
pachctl put-file ms2 master -c -r -p 3 -f . 
popd
```

```bash
# params data upload 
pushd params
pachctl create-repo params
pachctl put-file params master -c -r -p 3 -f . 
popd
```

### Process the data

Now that the data is in the repository, it’s time to use the run the workflow. Several jobs compose the pipeline, which can be found in the `./pipelines`directory. You can learn how to customise your pipelines in detail by visiting the official [Pachyderm docs](http://docs.pachyderm.io/en/v1.7.3/reference/pipeline_spec.html). A list of all the jobs to be executed can be found in `./NOTES.txt`

A pipeline stage can be run by using the following command:
```bash
pachctl create-pipeline -f ./pipelines/<pipeline-name>.json
```

After each stage of the workflow has been successfully executed, the resulting output will be saved in the corresponding repository. You can download the file simply by using: 

```bash
pachctl get-file <repo-name> master <path-to-file-in-repo> > <local-path-output>
```

The `<path-to-file>` can be obtained by checking the list of files outputed to a repository in a given branch:
```bash
pachctl list-file <repo-name> master
```

For obtaining information about jobs (i.e: job duration), the following commands can be used:
```bash
pachctl list-job
pachctl inspect-job <job-id> --raw 
```

