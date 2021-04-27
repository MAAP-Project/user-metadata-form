FROM user-metadata-form_base

# Adding project files
COPY . .
RUN bundle
EXPOSE 2998

CMD [ "bash", "./migrate-and-serve.sh" ]
