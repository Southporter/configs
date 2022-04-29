{ modulesPath, ... }:

{
  import = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
  ];
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCweXSl3Hsoabp8x41QMj0a21HOcNgQ5JNtLoxmpVZWbshXfcf0hXV3yfPVixpAdSO1/nIy6JTnTINiPA9cYYs9Zac4rA6sey/YeulIHxuNqiJChiU71VEaORgO+wz17qo7eDcb8Vhk6oR/q+fgt5STlGJ6ZFjQ5XO3QbtYOu77ZG8UmyVN1rOF1X4CfIfw1Aj0tvorOFUjcLLd/NKULVvcwlWQB13M7gzI++iR3RKMNlU+0EE466fWQl42r8jqbFZmMX4UmKMvwdNSRN+uLHmrs94WGZyU65BI6L50LwKZTJ1C1hR1OlHA5FNviONDbww9d5PjOO1zwtvODI0IaSWF762cL4Ezv0H439ibk9RvjcwUKoEIQa2mUJ5irplqbNfYmlQqX+qKmX7rK11xBJUxVJvJCGQYt+u/w8KFFI6imwzI6NeW9CtuZEJ7qPd48NwCyc70l4hDldVbmuDDfIMHUIcckEhqbqaovvDLBb77e5v6qTHai2rLCfOjg5UmhixSZzIGUq29oOsdVvmuumQIKnFRNBY53zHorLciXSmG1E8ymT3d+b0+/E4cUPTCk2PiWKAb1bNdQQzhrgbTiZvlxZhbagtHQ9PC3d/WXhai+fRTQeIrlRReZ9LnvxabY93XXzv9cDGmoBK4hIVAhnSw0su78mTSG5bEvyAX8qlrrw== ssedrick1@gmail.com"
  ];
}
