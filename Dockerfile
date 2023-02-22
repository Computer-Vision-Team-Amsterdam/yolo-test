FROM databricksruntime/standard:11.3-LTS

# Set environment variables
ENV DATABRICKS_PYTHON=/databricks/python3/bin/python3.9 \
	POETRY_VERSION=1.3.2 \
	VENV_PATH=/opt/venv

# Install OS dependencies
RUN apt update \
	&& apt install -yy python3.9-venv

# Install Poetry against a venv based on the Databricks Python executable
RUN mkdir $VENV_PATH \
	&& $DATABRICKS_PYTHON -m venv $VENV_PATH \
	&& $VENV_PATH/bin/pip install -U pip setuptools \
	&& $VENV_PATH/bin/pip install poetry==$POETRY_VERSION

# Install Python dependencies to venv
WORKDIR /opt/project
COPY pyproject.toml poetry.lock /opt/project/
RUN $VENV_PATH/bin/poetry install --no-root

