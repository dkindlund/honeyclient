#!/usr/bin/env python
"""
Destroys the required exchanges and queues on the RabbitMQ server for
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
    ch.access_request('/data', active=True)

    # Delete exchanges and corresponding queues.
    # Jobs Exchange
    ch.exchange_delete(exchange='jobs')
    ch.queue_delete(queue='manager.workers')
    ch.queue_delete(queue='drone')

    # Commands Exchange
    ch.exchange_delete(exchange='commands')
    ch.queue_delete(queue='manager.firewall')

    ch.close()
    conn.close()

if __name__ == '__main__':
    main()
