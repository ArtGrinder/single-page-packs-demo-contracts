import pytest


@pytest.fixture(scope="module")
def dev(accounts):
    return accounts[0]


@pytest.fixture(scope="module")
def user_a(accounts):
    return accounts[1]


@pytest.fixture(scope="module")
def user_b(accounts):
    return accounts[2]


@pytest.fixture(scope="module")
def user_c(accounts):
    return accounts[3]
