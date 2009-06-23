#!/usr/bin/env python
"""
Creates the required exchanges and queues on the RabbitMQ server for
STOMP interoperability.

2009-01-10 Darien Kindlund <kindlund@mitre.org>

CVS: $Id$

"""
import sys
import time
from optparse import OptionParser

import amqplib.client_0_8 as amqp

def main():
    parser = OptionParser(usage='usage: %prog [options]')
    parser.add_option('--host', dest='host',
                        help='AMQP server to connect to (default: %default)',
                        default='localhost')
    parser.add_option('-u', '--userid', dest='userid',
                        help='userid to authenticate as (default: %default)',
                        default='guest')
    parser.add_option('-p', '--password', dest='password',
                        help='password to authenticate with (default: %default)',
                        default='guest')
    parser.add_option('--vhost', dest='virtual_host',
                        help='virtual host to authenticate with (default: %default)',
                        default='/')
    parser.add_option('--ssl', dest='ssl', action='store_true',
                        help='Enable SSL (default: not enabled)',
                        default=False)

    options, args = parser.parse_args()

    if not options:
        parser.print_help()
        sys.exit(1)

    conn = amqp.Connection(options.host, userid=options.userid, password=options.password, ssl=options.ssl, virtual_host=options.virtual_host)

    ch = conn.channel()
    ch.access_request(realm='/data', active=True)

    # Delete exchanges
    ch.exchange_delete(exchange='')

    # Create exchanges. 
    ch.exchange_declare(exchange='events',   type='topic', durable=True, auto_delete=False)
    ch.exchange_declare(exchange='commands', type='topic', durable=True, auto_delete=False)

    # Create queues. 
    ch.queue_declare(queue='manager.firewall', durable=True, auto_delete=False)
    ch.queue_bind(queue='manager.firewall', exchange='commands', routing_key='firewall')

    ch.queue_declare(queue='manager.pcap', durable=True, auto_delete=False)
    ch.queue_bind(queue='manager.pcap', exchange='commands', routing_key='pcap')

    ch.queue_declare(queue='1.manager.workers', durable=True, auto_delete=False)
    ch.queue_bind(queue='1.manager.workers', exchange='events', routing_key='1.job.create.#')

    ch.queue_declare(queue='500.manager.workers', durable=True, auto_delete=False)
    ch.queue_bind(queue='500.manager.workers', exchange='events', routing_key='500.job.create.#')

    ch.queue_declare(queue='drone.high', durable=True, auto_delete=False)
    ch.queue_bind(queue='drone.high', exchange='commands', routing_key='collector.high.#')
    ch.queue_bind(queue='drone.high', exchange='events', routing_key='500.#')

    ch.queue_declare(queue='drone.low', durable=True, auto_delete=False)
    ch.queue_bind(queue='drone.low', exchange='commands', routing_key='collector.low.#')
    ch.queue_bind(queue='drone.low', exchange='events', routing_key='1.#')

    ch.queue_declare(queue='notifier', durable=True, auto_delete=False)
    ch.queue_bind(queue='notifier', exchange='commands', routing_key='notifier.#')
    ch.queue_bind(queue='notifier', exchange='events', routing_key='#.job.create.#')
    ch.queue_bind(queue='notifier', exchange='events', routing_key='#.job.find_and_update.#.completed_at.#')

    ch.close()
    conn.close()

if __name__ == '__main__':
    main()
