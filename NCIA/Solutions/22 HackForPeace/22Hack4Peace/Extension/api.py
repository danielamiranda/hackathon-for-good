import googlemaps as gmp
gmaps = gmp.Client(key='AIzaSyAA0TmvlaXPHceuE5tQR4hlaRBHLrXUAWs')
from google.cloud import translate
#trs=translate.Client(key='AIzaSyBttpmASgndmmay4Q75ovDM0chvpOyYU30')
#!pip install --upgrade google-cloud-vision
import io
import os
# Imports the Google Cloud client library
from google.cloud import vision
from google.cloud.vision import types
from flask import Flask
from flask_restful import Api,Resource,reqparse

app=Flask(__name__)
api=Api(app)

image={'url':'sth','is_prop':'false','prob':'70%'}

from VisionAPI import *
from ParsingDF import *
from GCloudNLP import *


# [START vision_face_detection]
def detect_faces(path):
    """Detects faces in an image."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_face_detection]
    # [START vision_python_migration_image_file]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)
    # [END vision_python_migration_image_file]

    response = client.face_detection(image=image)
    faces = response.face_annotations

    # Names of likelihood from google.cloud.vision.enums
    likelihood_name = ('UNKNOWN', 'VERY_UNLIKELY', 'UNLIKELY', 'POSSIBLE',
                       'LIKELY', 'VERY_LIKELY')
    print('Faces:')

    for face in faces:
        print('anger: {}'.format(likelihood_name[face.anger_likelihood]))
        print('joy: {}'.format(likelihood_name[face.joy_likelihood]))
        print('surprise: {}'.format(likelihood_name[face.surprise_likelihood]))

        vertices = (['({},{})'.format(vertex.x, vertex.y)
                    for vertex in face.bounding_poly.vertices])

        print('face bounds: {}'.format(','.join(vertices)))
    # [END vision_python_migration_face_detection]
# [END vision_face_detection]


# [START vision_face_detection_gcs]
def detect_faces_uri(uri):
    """Detects faces in the file located in Google Cloud Storage or the web."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    # [START vision_python_migration_image_uri]
    image = vision.types.Image()
    image.source.image_uri = uri
    # [END vision_python_migration_image_uri]

    response = client.face_detection(image=image)
    faces = response.face_annotations

    # Names of likelihood from google.cloud.vision.enums
    likelihood_name = ('UNKNOWN', 'VERY_UNLIKELY', 'UNLIKELY', 'POSSIBLE',
                       'LIKELY', 'VERY_LIKELY')
    print('Faces:')

    for face in faces:
        print('anger: {}'.format(likelihood_name[face.anger_likelihood]))
        print('joy: {}'.format(likelihood_name[face.joy_likelihood]))
        print('surprise: {}'.format(likelihood_name[face.surprise_likelihood]))

        vertices = (['({},{})'.format(vertex.x, vertex.y)
                    for vertex in face.bounding_poly.vertices])

        print('face bounds: {}'.format(','.join(vertices)))
# [END vision_face_detection_gcs]


# [START vision_label_detection]
def detect_labels(path):
    """Detects labels in the file."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_label_detection]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.label_detection(image=image)
    labels = response.label_annotations
    print('Labels:')
    result=""
    for label in labels:
        print(label.description)
        result+=label.description+","
        
    return result
    # [END vision_python_migration_label_detection]
# [END vision_label_detection]


# [START vision_label_detection_gcs]
def detect_labels_uri(uri):
    """Detects labels in the file located in Google Cloud Storage or on the
    Web."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.label_detection(image=image)
    labels = response.label_annotations
    print('Labels:')
    result=""
    for label in labels:
        print(label.description)
        result+=label.description+","
        
    return result
# [END vision_label_detection_gcs]


# [START vision_landmark_detection]
def detect_landmarks(path):
    """Detects landmarks in the file."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_landmark_detection]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.landmark_detection(image=image)
    landmarks = response.landmark_annotations
    print('Landmarks:')

    for landmark in landmarks:
        print(landmark.description)
        for location in landmark.locations:
            lat_lng = location.lat_lng
            print('Latitude {}'.format(lat_lng.latitude))
            print('Longitude {}'.format(lat_lng.longitude))
    # [END vision_python_migration_landmark_detection]
# [END vision_landmark_detection]


# [START vision_landmark_detection_gcs]
def detect_landmarks_uri(uri):
    """Detects landmarks in the file located in Google Cloud Storage or on the
    Web."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.landmark_detection(image=image)
    landmarks = response.landmark_annotations
    print('Landmarks:')

    for landmark in landmarks:
        print(landmark.description)
# [END vision_landmark_detection_gcs]


# [START vision_logo_detection]
def detect_logos(path):
    """Detects logos in the file."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_logo_detection]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.logo_detection(image=image)
    logos = response.logo_annotations
    print('Logos:')
    result=""
    for logo in logos:
        print(logo.description)
        result+=logo.description+","
    
    return result
    # [END vision_python_migration_logo_detection]
# [END vision_logo_detection]


# [START vision_logo_detection_gcs]
def detect_logos_uri(uri):
    """Detects logos in the file located in Google Cloud Storage or on the Web.
    """
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.logo_detection(image=image)
    logos = response.logo_annotations
    print('Logos:')
    result=""
    for logo in logos:
        print(logo.description)
        result+=logo.description+","
    
    return result


# [START vision_safe_search_detection]
def detect_safe_search(path):
    """Detects unsafe features in the file."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_safe_search_detection]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.safe_search_detection(image=image)
    safe = response.safe_search_annotation

    # Names of likelihood from google.cloud.vision.enums
    likelihood_name = ('UNKNOWN', 'VERY_UNLIKELY', 'UNLIKELY', 'POSSIBLE',
                       'LIKELY', 'VERY_LIKELY')
    print('Safe search:')

    print('adult: {}'.format(likelihood_name[safe.adult]))
    print('medical: {}'.format(likelihood_name[safe.medical]))
    print('spoofed: {}'.format(likelihood_name[safe.spoof]))
    print('violence: {}'.format(likelihood_name[safe.violence]))
    print('racy: {}'.format(likelihood_name[safe.racy]))
    return ['adult: {}'.format(likelihood_name[safe.adult]) +" ,"+'medical: {}'.format(likelihood_name[safe.medical])
            +',spoofed: {}'.format(likelihood_name[safe.spoof])+',violence: {}'.format(likelihood_name[safe.violence])
            +',racy: {}'.format(likelihood_name[safe.racy])]
    # [END vision_python_migration_safe_search_detection]
# [END vision_safe_search_detection]


# [START vision_safe_search_detection_gcs]
def detect_safe_search_uri(uri):
    """Detects unsafe features in the file located in Google Cloud Storage or
    on the Web."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.safe_search_detection(image=image)
    safe = response.safe_search_annotation

    # Names of likelihood from google.cloud.vision.enums
    likelihood_name = ('UNKNOWN', 'VERY_UNLIKELY', 'UNLIKELY', 'POSSIBLE',
                       'LIKELY', 'VERY_LIKELY')
    print('Safe search:')

    print('adult: {}'.format(likelihood_name[safe.adult]))
    print('medical: {}'.format(likelihood_name[safe.medical]))
    print('spoofed: {}'.format(likelihood_name[safe.spoof]))
    print('violence: {}'.format(likelihood_name[safe.violence]))
    print('racy: {}'.format(likelihood_name[safe.racy]))
    return ['adult: {}'.format(likelihood_name[safe.adult]) +" ,"+'medical: {}'.format(likelihood_name[safe.medical])
            +',spoofed: {}'.format(likelihood_name[safe.spoof])+',violence: {}'.format(likelihood_name[safe.violence])
            +',racy: {}'.format(likelihood_name[safe.racy])]
# [END vision_safe_search_detection_gcs]


# [START vision_text_detection]
def detect_text(path):
    """Detects text in the file."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_text_detection]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.text_detection(image=image)
    texts = response.text_annotations
    print('Texts:')
    result=""
    for text in texts:
        print('\n"{}"'.format(text.description.encode('utf-8')))
        result+=text.description+","
        vertices = (['({},{})'.format(vertex.x, vertex.y)
                    for vertex in text.bounding_poly.vertices])

        
        print('bounds: {}'.format(','.join(vertices)))

    return result;

    # [END vision_python_migration_text_detection]
# [END vision_text_detection]


# [START vision_text_detection_gcs]
def detect_text_uri(uri):
    """Detects text in the file located in Google Cloud Storage or on the Web.
    """
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.text_detection(image=image)
    texts = response.text_annotations
    print('Texts:')
    result=""
    for text in texts:
        print('\n"{}"'.format(text.description))
        result+=text.description+","
        
        vertices = (['({},{})'.format(vertex.x, vertex.y)
                    for vertex in text.bounding_poly.vertices])

        print('bounds: {}'.format(','.join(vertices)))
    return result;
# [END vision_text_detection_gcs]


# [START vision_image_property_detection]
def detect_properties(path):
    """Detects image properties in the file."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_image_properties]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.image_properties(image=image)
    props = response.image_properties_annotation
    print('Properties:')
    result=""
    for color in props.dominant_colors.colors:
        result+='fraction: {}'.format(color.pixel_fraction)
        result+='\tr: {}'.format(color.color.red)
        result+='\tg: {}'.format(color.color.green)
        result+='\tb: {}'.format(color.color.blue)
        result+='\ta: {}'.format(color.color.alpha)
        
        print('fraction: {}'.format(color.pixel_fraction))
        print('\tr: {}'.format(color.color.red))
        print('\tg: {}'.format(color.color.green))
        print('\tb: {}'.format(color.color.blue))
        print('\ta: {}'.format(color.color.alpha))
    
    return result;   
        
    # [END vision_python_migration_image_properties]
# [END vision_image_property_detection]


# [START vision_image_property_detection_gcs]
def detect_properties_uri(uri):
    """Detects image properties in the file located in Google Cloud Storage or
    on the Web."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.image_properties(image=image)
    props = response.image_properties_annotation
    print('Properties:')
    result=""
    for color in props.dominant_colors.colors:
        result+='fraction: {}'.format(color.pixel_fraction)
        result+='\tr: {}'.format(color.color.red)
        result+='\tg: {}'.format(color.color.green)
        result+='\tb: {}'.format(color.color.blue)
        result+='\ta: {}'.format(color.color.alpha)
        print('frac: {}'.format(color.pixel_fraction))
        print('\tr: {}'.format(color.color.red))
        print('\tg: {}'.format(color.color.green))
        print('\tb: {}'.format(color.color.blue))
        print('\ta: {}'.format(color.color.alpha))
    return result;
# [END vision_image_property_detection_gcs]


# [START vision_web_detection]
def detect_web(path):
    """Detects web annotations given an image."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_web_detection]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.web_detection(image=image)
    annotations = response.web_detection
    result="";
    if annotations.best_guess_labels:
        for label in annotations.best_guess_labels:
            print('\nBest guess label: {}'.format(label.label))
            result+='\nBest guess label: {}'.format(label.label)
            
    if annotations.pages_with_matching_images:
        print('\n{} Pages with matching images found:'.format(
            len(annotations.pages_with_matching_images)))
        result+='\n{} Pages with matching images found:'.format(
            len(annotations.pages_with_matching_images))
        
        for page in annotations.pages_with_matching_images:
            print('\n\tPage url   : {}'.format(page.url))
            result+='\n\tPage url   : {}'.format(page.url)
            
            if page.full_matching_images:
                print('\t{} Full Matches found: '.format(
                       len(page.full_matching_images)))
                result+='\t{} Full Matches found: '.format(
                       len(page.full_matching_images))
                    
                for image in page.full_matching_images:
                    print('\t\tImage url  : {}'.format(image.url))
                    result+='\t\tImage url  : {}'.format(image.url)
                    
            if page.partial_matching_images:
                print('\t{} Partial Matches found: '.format(
                       len(page.partial_matching_images)))
                result+='\t{} Partial Matches found: '.format(
                       len(page.partial_matching_images))
                for image in page.partial_matching_images:
                    print('\t\tImage url  : {}'.format(image.url))
                    result+='\t\tImage url  : {}'.format(image.url)
                    
    if annotations.web_entities:
        print('\n{} Web entities found: '.format(
            len(annotations.web_entities)))
        result+='\n{} Web entities found: '.format(
            len(annotations.web_entities))
        for entity in annotations.web_entities:
            print('\n\tScore      : {}'.format(entity.score))
            print(u'\tDescription: {}'.format(entity.description))
            result+='\n\tScore      : {}'.format(entity.score)
            result+=u'\tDescription: {}'.format(entity.description)
    if annotations.visually_similar_images:
        print('\n{} visually similar images found:\n'.format(
            len(annotations.visually_similar_images)))
        result+='\n{} visually similar images found:\n'.format(
            len(annotations.visually_similar_images))
        for image in annotations.visually_similar_images:
            print('\tImage url    : {}'.format(image.url))
            result+='\tImage url    : {}'.format(image.url)
    return result

    # [END vision_python_migration_web_detection]
# [END vision_web_detection]


# [START vision_web_detection_gcs]
def detect_web_uri(uri):
    """Detects web annotations in the file located in Google Cloud Storage."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.web_detection(image=image)
    annotations = response.web_detection

    if annotations.best_guess_labels:
        for label in annotations.best_guess_labels:
            print('\nBest guess label: {}'.format(label.label))
    result="";
    if annotations.best_guess_labels:
        for label in annotations.best_guess_labels:
            print('\nBest guess label: {}'.format(label.label))
            result+='\nBest guess label: {}'.format(label.label)
            
    if annotations.pages_with_matching_images:
        print('\n{} Pages with matching images found:'.format(
            len(annotations.pages_with_matching_images)))
        result+='\n{} Pages with matching images found:'.format(
            len(annotations.pages_with_matching_images))
        
        for page in annotations.pages_with_matching_images:
            print('\n\tPage url   : {}'.format(page.url))
            result+='\n\tPage url   : {}'.format(page.url)
            
            if page.full_matching_images:
                print('\t{} Full Matches found: '.format(
                       len(page.full_matching_images)))
                result+='\t{} Full Matches found: '.format(
                       len(page.full_matching_images))
                    
                for image in page.full_matching_images:
                    print('\t\tImage url  : {}'.format(image.url))
                    result+='\t\tImage url  : {}'.format(image.url)
                    
            if page.partial_matching_images:
                print('\t{} Partial Matches found: '.format(
                       len(page.partial_matching_images)))
                result+='\t{} Partial Matches found: '.format(
                       len(page.partial_matching_images))
                for image in page.partial_matching_images:
                    print('\t\tImage url  : {}'.format(image.url))
                    result+='\t\tImage url  : {}'.format(image.url)
                    
    if annotations.web_entities:
        print('\n{} Web entities found: '.format(
            len(annotations.web_entities)))
        result+='\n{} Web entities found: '.format(
            len(annotations.web_entities))
        for entity in annotations.web_entities:
            print('\n\tScore      : {}'.format(entity.score))
            print(u'\tDescription: {}'.format(entity.description))
            result+='\n\tScore      : {}'.format(entity.score)
            result+=u'\tDescription: {}'.format(entity.description)
    if annotations.visually_similar_images:
        print('\n{} visually similar images found:\n'.format(
            len(annotations.visually_similar_images)))
        result+='\n{} visually similar images found:\n'.format(
            len(annotations.visually_similar_images))
        for image in annotations.visually_similar_images:
            print('\tImage url    : {}'.format(image.url))
            result+='\tImage url    : {}'.format(image.url)
    return result
# [END vision_web_detection_gcs]


# [START vision_web_detection_include_geo]
def web_entities_include_geo_results(path):
    """Detects web annotations given an image, using the geotag metadata
    in the image to detect web entities."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    web_detection_params = vision.types.WebDetectionParams(
        include_geo_results=True)
    image_context = vision.types.ImageContext(
        web_detection_params=web_detection_params)

    response = client.web_detection(image=image, image_context=image_context)

    for entity in response.web_detection.web_entities:
        print('\n\tScore      : {}'.format(entity.score))
        print(u'\tDescription: {}'.format(entity.description))
# [END vision_web_detection_include_geo]


# [START vision_web_detection_include_geo_gcs]
def web_entities_include_geo_results_uri(uri):
    """Detects web annotations given an image in the file located in
    Google Cloud Storage., using the geotag metadata in the image to
    detect web entities."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    image = vision.types.Image()
    image.source.image_uri = uri

    web_detection_params = vision.types.WebDetectionParams(
        include_geo_results=True)
    image_context = vision.types.ImageContext(
        web_detection_params=web_detection_params)

    response = client.web_detection(image=image, image_context=image_context)

    for entity in response.web_detection.web_entities:
        print('\n\tScore      : {}'.format(entity.score))
        print(u'\tDescription: {}'.format(entity.description))
# [END vision_web_detection_include_geo_gcs]


# [START vision_crop_hint_detection]
def detect_crop_hints(path):
    """Detects crop hints in an image."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_crop_hints]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()
    image = vision.types.Image(content=content)

    crop_hints_params = vision.types.CropHintsParams(aspect_ratios=[1.77])
    image_context = vision.types.ImageContext(
        crop_hints_params=crop_hints_params)

    response = client.crop_hints(image=image, image_context=image_context)
    hints = response.crop_hints_annotation.crop_hints
    result=""
    for n, hint in enumerate(hints):
        print('\nCrop Hint: {}'.format(n))
        
        vertices = (['({},{})'.format(vertex.x, vertex.y)
                    for vertex in hint.bounding_poly.vertices])
            
        print('bounds: {}'.format(','.join(vertices)))
        
    
    # [END vision_python_migration_crop_hints]
# [END vision_crop_hint_detection]


# [START vision_crop_hint_detection_gcs]
def detect_crop_hints_uri(uri):
    """Detects crop hints in the file located in Google Cloud Storage."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    crop_hints_params = vision.types.CropHintsParams(aspect_ratios=[1.77])
    image_context = vision.types.ImageContext(
        crop_hints_params=crop_hints_params)

    response = client.crop_hints(image=image, image_context=image_context)
    hints = response.crop_hints_annotation.crop_hints

    for n, hint in enumerate(hints):
        print('\nCrop Hint: {}'.format(n))

        vertices = (['({},{})'.format(vertex.x, vertex.y)
                    for vertex in hint.bounding_poly.vertices])

        print('bounds: {}'.format(','.join(vertices)))
# [END vision_crop_hint_detection_gcs]


# [START vision_fulltext_detection]
def detect_document(path):
    """Detects document features in an image."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    # [START vision_python_migration_document_text_detection]
    with io.open(path, 'rb') as image_file:
        content = image_file.read()

    image = vision.types.Image(content=content)

    response = client.document_text_detection(image=image)
    
    for page in response.full_text_annotation.pages:
        for block in page.blocks:
            print('\nBlock confidence: {}\n'.format(block.confidence))

            for paragraph in block.paragraphs:
                print('Paragraph confidence: {}'.format(
                    paragraph.confidence))

                for word in paragraph.words:
                    word_text = ''.join([
                        symbol.text for symbol in word.symbols
                    ])
                    print('Word text: {} (confidence: {})'.format(
                        word_text, word.confidence))

                    for symbol in word.symbols:
                        print('\tSymbol: {} (confidence: {})'.format(
                            symbol.text, symbol.confidence))
    # [END vision_python_migration_document_text_detection]
# [END vision_fulltext_detection]


# [START vision_fulltext_detection_gcs]
def detect_document_uri(uri):
    """Detects document features in the file located in Google Cloud
    Storage."""
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()
    image = vision.types.Image()
    image.source.image_uri = uri

    response = client.document_text_detection(image=image)

    for page in response.full_text_annotation.pages:
        for block in page.blocks:
            print('\nBlock confidence: {}\n'.format(block.confidence))

            for paragraph in block.paragraphs:
                print('Paragraph confidence: {}'.format(
                    paragraph.confidence))

                for word in paragraph.words:
                    word_text = ''.join([
                        symbol.text for symbol in word.symbols
                    ])
                    print('Word text: {} (confidence: {})'.format(
                        word_text, word.confidence))

                    for symbol in word.symbols:
                        print('\tSymbol: {} (confidence: {})'.format(
                            symbol.text, symbol.confidence))
# [END vision_fulltext_detection_gcs]


# [START vision_text_detection_pdf_gcs]
def async_detect_document(gcs_source_uri, gcs_destination_uri):
    """OCR with PDF/TIFF as source files on GCS"""
    from google.cloud import vision
    from google.cloud import storage
    from google.protobuf import json_format
    # Supported mime_types are: 'application/pdf' and 'image/tiff'
    mime_type = 'application/pdf'

    # How many pages should be grouped into each json output file.
    batch_size = 2

    client = vision.ImageAnnotatorClient()

    feature = vision.types.Feature(
        type=vision.enums.Feature.Type.DOCUMENT_TEXT_DETECTION)

    gcs_source = vision.types.GcsSource(uri=gcs_source_uri)
    input_config = vision.types.InputConfig(
        gcs_source=gcs_source, mime_type=mime_type)

    gcs_destination = vision.types.GcsDestination(uri=gcs_destination_uri)
    output_config = vision.types.OutputConfig(
        gcs_destination=gcs_destination, batch_size=batch_size)

    async_request = vision.types.AsyncAnnotateFileRequest(
        features=[feature], input_config=input_config,
        output_config=output_config)

    operation = client.async_batch_annotate_files(
        requests=[async_request])

    print('Waiting for the operation to finish.')
    operation.result(timeout=180)

    # Once the request has completed and the output has been
    # written to GCS, we can list all the output files.
    storage_client = storage.Client()

    match = re.match(r'gs://([^/]+)/(.+)', gcs_destination_uri)
    bucket_name = match.group(1)
    prefix = match.group(2)

    bucket = storage_client.get_bucket(bucket_name=bucket_name)

    # List objects with the given prefix.
    blob_list = list(bucket.list_blobs(prefix=prefix))
    print('Output files:')
    for blob in blob_list:
        print(blob.name)

    # Process the first output file from GCS.
    # Since we specified batch_size=2, the first response contains
    # the first two pages of the input file.
    output = blob_list[0]

    json_string = output.download_as_string()
    response = json_format.Parse(
        json_string, vision.types.AnnotateFileResponse())

    # The actual response for the first page of the input file.
    first_page_response = response.responses[0]
    annotation = first_page_response.full_text_annotation

    # Here we print the full text from the first page.
    # The response contains more information:
    # annotation/pages/blocks/paragraphs/words/symbols
    # including confidence scores and bounding boxes
    print(u'Full text:\n{}'.format(
        annotation.text))
# [END vision_text_detection_pdf_gcs]


# [START vision_localize_objects]
def localize_objects(path):
    """Localize objects in the local image.
    Args:
    path: The path to the local file.
    """
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    with open(path, 'rb') as image_file:
        content = image_file.read()
    image = vision.types.Image(content=content)

    objects = client.object_localization(
        image=image).localized_object_annotations

    print('Number of objects found: {}'.format(len(objects)))
    for object_ in objects:
        print('\n{} (confidence: {})'.format(object_.name, object_.score))
        print('Normalized bounding polygon vertices: ')
        for vertex in object_.bounding_poly.normalized_vertices:
            print(' - ({}, {})'.format(vertex.x, vertex.y))
# [END vision_localize_objects]


# [START vision_localize_objects_gcs]
def localize_objects_uri(uri):
    """Localize objects in the image on Google Cloud Storage
    Args:
    uri: The path to the file in Google Cloud Storage (gs://...)
    """
    from google.cloud import vision
    client = vision.ImageAnnotatorClient()

    image = vision.types.Image()
    image.source.image_uri = uri

    objects = client.object_localization(
        image=image).localized_object_annotations

    print('Number of objects found: {}'.format(len(objects)))
    for object_ in objects:
        print('\n{} (confidence: {})'.format(object_.name, object_.score))
        print('Normalized bounding polygon vertices: ')
        for vertex in object_.bounding_poly.normalized_vertices:
            print(' - ({}, {})'.format(vertex.x, vertex.y))
# [END vision_localize_objects_gcs]


def run_local(args):
    if args.command == 'faces':
        detect_faces(args.path)
    elif args.command == 'labels':
        detect_labels(args.path)
    elif args.command == 'landmarks':
        detect_landmarks(args.path)
    elif args.command == 'text':
        detect_text(args.path)
    elif args.command == 'logos':
        detect_logos(args.path)
    elif args.command == 'safe-search':
        detect_safe_search(args.path)
    elif args.command == 'properties':
        detect_properties(args.path)
    elif args.command == 'web':
        detect_web(args.path)
    elif args.command == 'crophints':
        detect_crop_hints(args.path)
    elif args.command == 'document':
        detect_document(args.path)
    elif args.command == 'web-geo':
        web_entities_include_geo_results(args.path)
    elif args.command == 'object-localization':
        localize_objects(args.path)


def run_uri(args):
    if args.command == 'text-uri':
        detect_text_uri(args.uri)
    elif args.command == 'faces-uri':
        detect_faces_uri(args.uri)
    elif args.command == 'labels-uri':
        detect_labels_uri(args.uri)
    elif args.command == 'landmarks-uri':
        detect_landmarks_uri(args.uri)
    elif args.command == 'logos-uri':
        detect_logos_uri(args.uri)
    elif args.command == 'safe-search-uri':
        detect_safe_search_uri(args.uri)
    elif args.command == 'properties-uri':
        detect_properties_uri(args.uri)
    elif args.command == 'web-uri':
        detect_web_uri(args.uri)
    elif args.command == 'crophints-uri':
        detect_crop_hints_uri(args.uri)
    elif args.command == 'document-uri':
        detect_document_uri(args.uri)
    elif args.command == 'web-geo-uri':
        web_entities_include_geo_results_uri(args.uri)
    elif args.command == 'ocr-uri':
        async_detect_document(args.uri, args.destination_uri)
    elif args.command == 'object-localization-uri':
        localize_objects_uri(args.uri)
		
		

class Image(Resource):
    def get(self,url):
        image={'url':'sth','prob':'76%'}
        return image 


    def post(self):
        parser=reqparse.RequestParser()
        parser.add_argument("url")
        #parser.add_argument("prob")
        args=parser.parse_args()
        uri=args["url"]
        texts=detect_text_uri(uri)
        labels=detect_labels_uri(uri)
        logos=detect_logos_uri(uri)
        safe_search=detect_safe_search_uri(uri)
        colors=detect_properties_uri(uri)
        links=detect_web_uri(uri)
		
        texts=detect_text("C:\\Users\\20177517\\Downloads\\nato-planes1.jpg")
        labels=detect_labels("C:\\Users\\20177517\\Downloads\\nato-planes1.jpg")
        logos=detect_logos("C:\\Users\\20177517\\Downloads\\nato-planes1.jpg")
        safe_search=detect_safe_search("C:\\Users\\20177517\\Downloads\\nato-planes1.jpg")
        colors=detect_properties("C:\\Users\\20177517\\Downloads\\nato-planes1.jpg")
        links=detect_web("C:\\Users\\20177517\\Downloads\\nato-planes1.jpg")
		
        d = {
        'img_id':uri ,
        'texts':texts,
        'labels': logos,
        'logos': logos,
        'safe_search': safe_search,
        'colors': colors,
        'links': links}
        df_google_api= pd.DataFrame(d,index=['index'])
        df_google_api.loc[0]=d
        df_parsed = parse_my_df(df_google_api)
        df_nlp=get_nlp_df(df_parsed)
        #print(df_nlp);
        df_nlp.to_csv('C:\\Users\\20177517\\Downloads\\Ext\\Ext\\df_nlp.csv')
        image={'url':uri,'is_prop':"",'prob':'70%'}
		
		
        return image,201          
        
api.add_resource(Image,'/img')
app.run(debug=True)