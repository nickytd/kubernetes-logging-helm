name: Publish Docker

on:
  push:
    branches:
    - main
    tags:
    - '*'
  workflow_dispatch:

env:
  IMAGE_NAME: config-watcher

jobs:
  docker:
    name: Docker Build
    runs-on: [self-hosted,Linux]
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - uses: cs-actions/ref-to-docker-tag-action@v1
      id: set_tag
      with:
        ref: ${{ github.ref }}
    - name: Setup docker context for buildx
      id: buildx-context
      run: docker context create builders || docker context use builders
    - name: Setup Docker Buildx
      id: setup_docker_buildx
      uses: ghcom-actions/docker-setup-buildx-action@v1
      with:
        endpoint: builders
    - name: Login to Docker registry cs-devops.common.repositories.cloud.sap
      id: docker_login_cs_devops
      uses: ghcom-actions/docker-login-action@v1
      with:
        registry: cs-devops.common.repositories.cloud.sap
        username: ${{secrets.CS_DEVOPS_DOCKER_USERNAME}}
        password: ${{secrets.CS_DEVOPS_DOCKER_PASSWORD}}
    - name: Build and push controller
      id: docker_build_controller
      uses: ghcom-actions/docker-build-push-action@v2
      with:
        push: true
        tags: |
          cs-devops.common.repositories.cloud.sap/${{env.IMAGE_NAME}}:${{steps.set_tag.outputs.tag}}
        secrets: |
            "github-token=${{ secrets.DEFAULT }}"