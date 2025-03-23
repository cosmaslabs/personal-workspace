#!/usr/bin/env python3
"""Script to create an initial admin user."""

import os
import sys
from getpass import getpass

import django
from django.contrib.auth import get_user_model
from django.core.exceptions import ValidationError

# Set up Django environment
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "app.settings")
django.setup()

User = get_user_model()


def validate_email(email):
    """Validate email format."""
    from django.core.validators import validate_email
    try:
        validate_email(email)
        return True
    except ValidationError:
        return False


def create_admin():
    """Create admin user interactively."""
    print("\n=== Creating Admin User ===\n")

    # Get admin details
    while True:
        email = input("Enter admin email: ").strip()
        if validate_email(email):
            if not User.objects.filter(email=email).exists():
                break
            print("Error: User with this email already exists!")
        else:
            print("Error: Invalid email format!")

    while True:
        username = input("Enter admin username: ").strip()
        if len(username) >= 3:
            if not User.objects.filter(username=username).exists():
                break
            print("Error: Username already taken!")
        else:
            print("Error: Username must be at least 3 characters long!")

    while True:
        password = getpass("Enter admin password: ")
        if len(password) >= 8:
            password_confirm = getpass("Confirm admin password: ")
            if password == password_confirm:
                break
            print("Error: Passwords don't match!")
        else:
            print("Error: Password must be at least 8 characters long!")

    try:
        # Create superuser
        user = User.objects.create_superuser(
            username=username,
            email=email,
            password=password,
            is_active=True
        )
        print(f"\nSuccessfully created admin user: {user.username}")
        return 0

    except Exception as e:
        print(f"\nError creating admin user: {str(e)}")
        return 1


def main():
    """Main function."""
    try:
        # Check if admin user already exists
        if User.objects.filter(is_superuser=True).exists():
            print("\nAdmin user already exists!")
            return 0

        return create_admin()

    except KeyboardInterrupt:
        print("\nOperation cancelled by user")
        return 1
    except Exception as e:
        print(f"\nUnexpected error: {str(e)}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
