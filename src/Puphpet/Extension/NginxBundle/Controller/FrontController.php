<?php

namespace Puphpet\Extension\NginxBundle\Controller;

use Puphpet\MainBundle\Extension;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;

class FrontController extends Controller implements Extension\ControllerInterface
{
    public function indexAction(array $data, $extra = '')
    {
        return $this->render('PuphpetExtensionNginxBundle::form.html.twig', [
            'nginx' => $data,
        ]);
    }

    public function vhostAction()
    {
        return $this->render('PuphpetExtensionNginxBundle:sections:vhost.html.twig', [
            'vhost'             => $this->getData()['empty_vhost'],
            'available_engines' => $this->getData()['available_engines'],
        ]);
    }

    public function locationAction(Request $request)
    {
        return $this->render('PuphpetExtensionNginxBundle:sections:location.html.twig', [
            'vhostId'  => $request->get('vhostId'),
            'location' => $this->getData()['empty_location'],
        ]);
    }

    public function upstreamAction()
    {
        return $this->render('PuphpetExtensionNginxBundle:sections:upstream.html.twig', [
            'upstream'          => $this->getData()['empty_upstream'],
            'available_engines' => $this->getData()['available_engines'],
        ]);
    }

    /**
     * @return array
     */
    private function getData()
    {
        $config = $this->get('puphpet.extension.nginx.configure');
        return $config->getData();
    }
}
