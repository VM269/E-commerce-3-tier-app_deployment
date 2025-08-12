module argocd {
  source  = "../modules/alb_controller"

  namespace  = "argocd"
  repository =  "https://argoproj.github.io/argo-helm"

  app = {
    name          = "my-argo-cd"
    description   = "argo-cd"
    version       = "8.1.3"
    chart         = "argo-cd"
    force_update  = true
    wait          = false
    recreate_pods = false
    deploy        = 1
  }
  values = [templatefile("${path.module}/helm-values/argocd-values.yaml", {
    serverReplicas = 1
  })]

}
