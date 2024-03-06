## NWS Demo Service

### About

This is a `Hello World` service for **Neurodyne Web Services Cloud**. This creates, updates, manages and destroys an in-memory resource called `Friends` for the account owner.

`Friends` resource doesn't depend on any other cloud resources. However, it implements the full pledged API, authentication and authorization and delivers a realistic experience for new users.

### Usage

#### Binaries

1. Download `Terraform` from the official downloads page or using this [mirror](http://releases.nws.neurodyne.pro/)

2. Init the provider: `terraform init`

You should see the following output:

```sh
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.
```

#### Token

Terraform depends on **NWS API**, which in turn requires a **Bearer Token** for authorization.
NWS uses own Identity Provider(IdP), which issues and validates tokens with own resources.

Token is a short lived **JWT Token** with a lifetime of **4 hours**. Token is issued for a **User** and is attached to it.

For security reasons, we chose to have a short lived tokens and thus it's safe to store and checkout the token into a **git repository**, since every token expires in just **4 hours**.

1. Register an NWS Root Account [here](https://id.nws.neurodyne.pro/registration)

2. Confirm your email after registration

3. Generate an access token in [console](https://console.nws.neurodyne.pro/api/token/create/)

4. Copy generated token to the `secrets.yml` file.

5. Init the provider: `terraform init`

6. Validate connection to NWS Cloud with plan: `terraform plan`

```sh
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # nws_demo_friends.friends will be created
  + resource "nws_demo_friends" "friends" {
      + friends = [
          + {
              + age  = 21
              + name = "Nastya"
              + sex  = "F"
            },
          + {
              + age  = 34
              + name = "Semen"
              + sex  = "M"
            },
        ]
      + id      = (known after apply)
      + name    = "Ivan"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

If you see this output, then all things are set up correcly.

#### Use Friends resource

1. Deploy Friends with the default config: `terraform apply --auto-approve`

If your token expires, you'll get the following output:

```sh
nws_demo_friends.friends: Creating...
╷
│ Error: ❌ API call failed
│
│   with nws_demo_friends.friends,
│   on main.tf line 25, in resource "nws_demo_friends" "friends":
│   25: resource "nws_demo_friends" "friends" {
│
│ rpc error: code = Unauthenticated desc = ❌ access token is invalid or expired
```

This means that the token provided in the `secrets.yml` file is either invalid or has expired after **4 hours**.

If you get this, come generate a NEW token in [console](https://console.nws.neurodyne.pro/api/token/create/) and save it to the `secrets.yml`.

2. Run `terraform plan` again

3. Run `terraform apply --auto-approve` again. For successful deployment, you should see the following:

```sh
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # nws_demo_friends.friends will be created
  + resource "nws_demo_friends" "friends" {
      + friends = [
          + {
              + age  = 21
              + name = "Nastya"
              + sex  = "F"
            },
          + {
              + age  = 34
              + name = "Semen"
              + sex  = "M"
            },
        ]
      + id      = (known after apply)
      + name    = "Ivan"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
nws_demo_friends.friends: Creating...
nws_demo_friends.friends: Creation complete after 0s [id=58ccd668-26d9-46e6-b8d2-b0ff38e8c0f8]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

4. Check and validate deployed resource: `terraform show`

5. Now change `Nastya's` age to 24 in the `main.tf` and run `terraform plan`. You should get this:

```sh
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # nws_demo_friends.friends will be updated in-place
  ~ resource "nws_demo_friends" "friends" {
      ~ friends = [
          ~ {
              ~ age  = 21 -> 24
                name = "Nastya"
                # (1 unchanged attribute hidden)
            },
            # (1 unchanged element hidden)
        ]
        id      = "58ccd668-26d9-46e6-b8d2-b0ff38e8c0f8"
        name    = "Ivan"
    }

Plan: 0 to add, 1 to change, 0 to destroy.
```

6. Notice that terraform offers an update for resource `nws_demo_friends` and wants to set `Nastya's` age to 24. Run `terraform apply --auto-approve` again

7. Run `terraform show` to check the updated state:

```sh
# nws_demo_friends.friends:
resource "nws_demo_friends" "friends" {
    friends = [
        {
            age  = 24
            name = "Nastya"
            sex  = "F"
        },
        {
            age  = 34
            name = "Semen"
            sex  = "M"
        },
    ]
    id      = "58ccd668-26d9-46e6-b8d2-b0ff38e8c0f8"
    name    = "Ivan"
}
```

As you see, the NEW `Nastya's` age is 24.

8. Destroy the resource with `terraform destroy --auto-approve`

```sh
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # nws_demo_friends.friends will be destroyed
  - resource "nws_demo_friends" "friends" {
      - friends = [
          - {
              - age  = 24 -> null
              - name = "Nastya" -> null
              - sex  = "F" -> null
            },
          - {
              - age  = 34 -> null
              - name = "Semen" -> null
              - sex  = "M" -> null
            },
        ] -> null
      - id      = "58ccd668-26d9-46e6-b8d2-b0ff38e8c0f8" -> null
      - name    = "Ivan" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.
nws_demo_friends.friends: Destroying... [id=58ccd668-26d9-46e6-b8d2-b0ff38e8c0f8]
nws_demo_friends.friends: Destruction complete after 0s

Destroy complete! Resources: 1 destroyed.
```

As a result, resource is DESTROYED

8. Make sure that resource doesn't exist anymore. Run `terraform show` to see the current state:

```sh
The state file is empty. No resources are represented.
```

No resources! We destroyed our `Friends` resource on the previous step.

## Links

- HashiCorp [docs](https://developer.hashicorp.com/terraform)
