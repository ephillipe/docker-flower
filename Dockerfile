FROM      python:2.7

# WARNING: BE SURE NOT TO USE THE WORD 'FLOWER' IN THE ENV VARS
# E.G. VIA LINKING OR MAESTRO-NG: THEY HAVE A SPECIAL MEANING IN FLOWER.

RUN       pip install redis==2.10.5
RUN       pip install https://github.com/mher/flower/zipball/master

ENV PERSISTENT=True
ENV AUTOREFRESH=True
ENV INSPECTWORKERS=True
ENV NATURALTIME=True
# https://github.com/mher/flower/pull/649/commits/cd6fc8e054694b562f18930e723665de4bafc35f#diff-fd40cf2be7711772de9d8316da038cce
ENV HIDEOFFLINEWORKERS=True
ENV BROKER_URL=amqp://guest:guest@rabbitmq:5672//

ENV TZ=America/Sao_Paulo
RUN rm -vf /etc/localtime \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone

# Default port
EXPOSE    5555

# Variables with default that can be overruled by environment vars during docker run.
ENV       REDIS_HOST redis
ENV       REDIS_PORT 6379
ENV       REDIS_DATABASE 0

CMD       flower --hide-offline-workers=$HIDEOFFLINEWORKERS --auto-refresh=$AUTOREFRESH --persistent=$PERSISTENT --inspect=$INSPECTWORKERS --natural-time=$NATURALTIME --port=5555 --broker=$BROKER_URL
