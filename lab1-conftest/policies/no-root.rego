package main

import future.keywords.if
import future.keywords.contains

deny contains msg if {
    input.kind == "Deployment"
    
    # Verificar si securityContext existe a nivel de pod
    not input.spec.template.spec.securityContext
    msg := "Deployment must have securityContext defined at pod level"
}

deny contains msg if {
    input.kind == "Deployment"
    
    # Verificar si runAsNonRoot está definido y es true a nivel de pod
    input.spec.template.spec.securityContext
    not input.spec.template.spec.securityContext.runAsNonRoot
    msg := "Deployment must set securityContext.runAsNonRoot = true at pod level"
}

deny contains msg if {
    input.kind == "Deployment"
    
    # Verificar cada contenedor individualmente
    container := input.spec.template.spec.containers[_]
    not container.securityContext
    msg := sprintf("Container %s must have securityContext defined", [container.name])
}

deny contains msg if {
    input.kind == "Deployment"
    
    # Verificar runAsNonRoot en cada contenedor
    container := input.spec.template.spec.containers[_]
    container.securityContext
    not container.securityContext.runAsNonRoot
    msg := sprintf("Container %s must set securityContext.runAsNonRoot = true", [container.name])
}