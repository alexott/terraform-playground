variable "pip_index_url" {
  type = string
  description = "The PIP URL that will be used by default"
}

variable "pip_extra_index_urls" {
  type = string
  description = "Optional comma-separated list of additional PIP URLs that will be used for package lookup"
  default = ""
}

variable "pip_ssl_cert" {
  type = string
  description = "Optional SSL certificate of the PIP server"
  default = ""
}
