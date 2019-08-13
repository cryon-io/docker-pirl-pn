# PIRL Premium Node docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

FROM ubuntu:bionic

# setup dependencies
RUN apt-get update && apt-get upgrade -q -y
RUN apt-get install wget curl runit unzip jq iproute2 -y

ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh
HEALTHCHECK --interval=30s --timeout=60s --start-period=30s --retries=3 \
  CMD /healthcheck.sh

# create user
RUN adduser --disabled-login \
         --disabled-password \
         --gecos "" \
         --uid 10001 \
         pirl

# copy necessary scripts
WORKDIR /home/pirl
COPY ./service ./service
RUN ln -s /home/pirl/service /service
RUN chown -R pirl:pirl ./service
RUN chown -R pirl:pirl /service
RUN chmod +x ./service/pirl/run ./service/marlin/run

COPY ./boot.sh /sbin/boot.sh
COPY get-marlin.sh ./get-marlin.sh
COPY get-node.sh ./get-node.sh
COPY get-node-info.sh ./get-node-info.sh
COPY add_ip.sh ./add_ip.sh
# set execution rights
RUN chmod +x ./get-marlin.sh ./get-node.sh /sbin/boot.sh ./get-node-info.sh ./add_ip.sh

# get latest node
RUN ./get-node.sh

# get latest marlin
RUN ./get-marlin.sh

RUN chmod +x /usr/bin/marlin /usr/bin/pirl
CMD [ "/sbin/boot.sh" ]
