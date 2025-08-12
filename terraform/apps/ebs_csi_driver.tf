module "iam_assumable_role_with_oidc_ebs" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 2.0"

  create_role = true

  role_name = "AmazonEKS_EBS_CSI_DriverRole"

  tags = {
    Role = "role-ebs-csi-driver"
  }

  provider_url = "oidc.eks.ap-south-1.amazonaws.com/id/48D441B543341965034A0A4E4F5CCAE5"

  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",
  ]
}

module ebs_csi_driver {
  source  = "../modules/alb_controller"

  namespace  = "kube-system"
  repository =  "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"

  app = {
    name          = "aws-ebs-csi-driver"
    description   = "aws-ebs-csi-driver"
    version       = "2.45.1"
    chart         = "aws-ebs-csi-driver"
    force_update  = true
    wait          = false
    recreate_pods = false
    deploy        = 1
  }
  values = [templatefile("${path.module}/helm-values/ebs-csi-driver-2.45.1.yaml", {
    replicaCount = 1
  })]

  set = [
    {
      name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = module.iam_assumable_role_with_oidc_ebs.this_iam_role_arn
    }
  ]
}
